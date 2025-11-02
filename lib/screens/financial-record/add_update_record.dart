import 'package:finmene/models/entities/report.dart';
import 'package:finmene/providers/bookkeeping/bookkeeping_provider.dart';
import 'package:finmene/utils/enums/category_enum.dart';
import 'package:finmene/utils/enums/snackbar_enum.dart';
import 'package:finmene/utils/enums/status_state_enum.dart';
import 'package:finmene/utils/extensions/context_extensions.dart';
import 'package:finmene/utils/formatters/common_input_formatters.dart';
import 'package:finmene/utils/res/string_res.dart';
import 'package:finmene/utils/utilities.dart';
import 'package:finmene/utils/views/provider_listener.dart';
import 'package:finmene/utils/widgets/buttons/button_primary.dart';
import 'package:finmene/utils/widgets/fields/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddUpdateArgument {
  final bool isEditForm;
  final Report report;
  final int index;

  AddUpdateArgument({
    this.isEditForm = false,
    required this.report,
    required this.index,
  });
}

class AddUpdateRecord extends StatefulWidget {
  const AddUpdateRecord({super.key, this.argument});

  final AddUpdateArgument? argument;

  @override
  State<AddUpdateRecord> createState() => _AddUpdateRecordState();
}

class _AddUpdateRecordState extends State<AddUpdateRecord> {
  late TextEditingController dateTimeController;
  late TextEditingController ammountController;
  late TextEditingController descriptionController;
  DateTime selectedDate = DateTime.now();
  CategoryType? _selectedCategory;

  bool isDateTimeValid = false;
  bool isAmmountValid = false;
  bool isCategoryValid = false;
  var currenyFormatter = CurrencyFormatter(prefix: "", maxDigits: 12);

  void _onAmountChanged(String value) {
    setState(() {
      isAmmountValid =
          ammountController.text.isNotEmpty &&
          (double.tryParse(ammountController.text) != 0.0);
    });
  }

  void _onCategoryChanged(CategoryType? val) {
    setState(() {
      isCategoryValid = val != null;
      _selectedCategory = val;
    });
  }

  bool _validateAndSave() {
    return isDateTimeValid && isAmmountValid && isCategoryValid;
  }

  @override
  void initState() {
    dateTimeController = TextEditingController();
    ammountController = TextEditingController();
    descriptionController = TextEditingController();
    if (widget.argument != null && widget.argument!.isEditForm) {
      dateTimeController.text = DateFormat(
        'dd-MM-yyyy HH:mm',
      ).format(widget.argument!.report.trxDate);
      ammountController.text = widget.argument!.report.ammount.toString();
      descriptionController.text = widget.argument!.report.description ?? "";
      _selectedCategory = widget.argument!.report.category;
      isDateTimeValid = true;
      isAmmountValid = true;
      isCategoryValid = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    dateTimeController.dispose();
    ammountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date
      firstDate: DateTime(2000), // Earliest date
      lastDate: DateTime(2101), // Latest date
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(),
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
          );
        },
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        final formattedDate = DateFormat(
          'dd-MM-yyyy HH:mm',
        ).format(selectedDate);

        setState(() {
          selectedDate = selectedDateTime;
          dateTimeController.text = formattedDate;
          isDateTimeValid = dateTimeController.text.isNotEmpty;
        });
      }
    }
  }

  void clearForm() {
    setState(() {
      dateTimeController.clear();
      ammountController.clear();
      descriptionController.clear();
      selectedDate = DateTime.now();
      _selectedCategory = null;
      isDateTimeValid = false;
      isAmmountValid = false;
      isCategoryValid = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.argument != null && widget.argument!.isEditForm ? "Edit Pencatatan" : "Tambah Pencatatan")
      ),
      body: SingleChildScrollView(
        child: ProviderListenerWidget<BookkeepingProvider>(
          listener: (context, value) {
            var stateAdd = value.reportsState.state;
            if (stateAdd.isLoading) {
              Utilities.showLoadingDialog(context);
            } else if (stateAdd.isSuccess) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              clearForm();
              Utilities.showSnackbar(
                context,
                SnackbarEnum.success,
                widget.argument != null && widget.argument!.isEditForm ? "Berhasil melakukan perubahan" : "Berhasil menambahkan pencatatan",
              );
            } else if (stateAdd.isError) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Utilities.showSnackbar(
                context,
                SnackbarEnum.success,
                widget.argument != null && widget.argument!.isEditForm ? "Gagal melakukan perubahan" : "Gagal menambahkan pencatatan",
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_formAddEditReport(), _buttonLogin()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formAddEditReport() {
    return Column(
      children: [
        RegularTextFormField(
          controller: dateTimeController,
          label: "Pilih Tanggal",
          keyboardType: TextInputType.none,
          inputAction: TextInputAction.next,
          showClearIcon: false,
          onTap: () => _selectDate(context),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Pilih tanggal terlebih dahulu';
            }
            return null;
          },
        ),
        Gap(25),
        DropdownButtonFormField(
          isExpanded: true,
          hint: Text("Pilih Kategori"),
          decoration: InputDecoration(
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1),
            ),
          ),
          borderRadius: BorderRadius.circular(16),
          initialValue: _selectedCategory,
          items: CategoryType.values.map((item) {
            return DropdownMenuItem(value: item, child: Text(item.labelName));
          }).toList(),
          onChanged: _onCategoryChanged,
        ),
        Gap(25),
        RegularTextFormField(
          controller: ammountController,
          label: "Jumlah",
          prefix: Text("Rp. ", style: context.textTheme.bodyMedium),
          keyboardType: TextInputType.number,
          inputAction: TextInputAction.next,
          inputFormatter: [
            FilteringTextInputFormatter.digitsOnly,
            currenyFormatter,
          ],
          showClearIcon: false,
          onChanged: _onAmountChanged,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Jumlah tidak boleh kosong';
            }
            return null;
          },
        ),
        Gap(25),
        RegularTextFormField(
          controller: descriptionController,
          label: "Deskripsi (optional)",
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 5,
          inputAction: TextInputAction.done,
          showClearIcon: false,
        ),
        Gap(25),
      ],
    );
  }

  Widget _buttonLogin() => ButtonPrimary(
    title: widget.argument != null && widget.argument!.isEditForm ? "Edit Pencatatan" : StringRes.addButton,
    onPressed: _validateAndSave()
        ? () {
            Report report = Report(
              trxDate: selectedDate,
              category: _selectedCategory!,
              ammount: currenyFormatter.getConvertToDouble(),
              description: descriptionController.text,
            );
            if (widget.argument != null && widget.argument!.isEditForm) {
              context.read<BookkeepingProvider>().editReport(report, widget.argument!.index);
            } else {
              context.read<BookkeepingProvider>().addNewReport(report);
            }
          }
        : null,
  );
}
