import 'package:finmene/providers/bookkeeping/bookkeeping_provider.dart';
import 'package:finmene/screens/home/widget/card_information.dart';
import 'package:finmene/utils/enums/status_state_enum.dart';
import 'package:finmene/utils/extensions/context_extensions.dart';
import 'package:finmene/utils/extensions/num_extensions.dart';
import 'package:finmene/utils/res/image_res.dart';
import 'package:finmene/utils/res/string_res.dart';
import 'package:finmene/utils/theme/app_colors.dart';
import 'package:finmene/utils/utilities.dart';
import 'package:finmene/utils/widgets/menu_with_more_btn.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    Future.microtask(() async {
      if (mounted) context.read<BookkeepingProvider>().loadReports();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_upperInformation(context), Gap(10), lastThreeRecord()],
          ),
        ),
      ),
    );
  }

  Widget _upperInformation(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              color: AppColors.tertiary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _appBarInfo(context),
              Gap(24),
              _greetingMessage(context),
              Gap(24),
              _cardInformation(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _appBarInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Image.asset(
              ImageRes.logoNoBg,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            Text(
              StringRes.applicationName,
              style: context.textTheme.bodyLarge!.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded)),
      ],
    );
  }

  Widget _greetingMessage(BuildContext context) {
    final auth = context.currentUser;
    return Text(
      "Wellcome back\n${auth?.name}",
      style: context.textTheme.headlineMedium!.copyWith(),
    );
  }

  Widget _cardInformation() {
    return Row(
      children: [
        Expanded(
          child: CardInformation.income(
            total: "1.000.000",
            lastTransaction: "150.000",
          ),
        ),
        Expanded(
          child: CardInformation.expense(
            total: "2.500.000",
            lastTransaction: "200.000",
          ),
        ),
      ],
    );
  }

  Widget lastThreeRecord() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        MenuWithMoreBtn(title: StringRes.lastRecordTitle, onTap: () {}),
        Consumer<BookkeepingProvider>(
          builder: (context, state, _) {
            var stateProvider = state.reportsState.state;
            if (stateProvider.isLoading) {
              return Column(
                children: List.generate(
                  3,
                  (index) => Utilities.shimmerPlaceholder()
                ),
              );
            } else if (stateProvider.isError) {
              return Center(child: Text("Terjadi kesalahan saat memuat data"));
            } else if (stateProvider.isLoaded || stateProvider.isSuccess) {
              if (state.reports.isEmpty) {
                return SizedBox(
                  height: 300,
                  child: Center(child: Text("Belum ada catatan keuangan")),
                );
              }
              final listReport = state.reports.take(4).toList();
              return Column(
                children: listReport.map((val) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.fastfood_rounded),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(val.category.labelName),
                          Text(
                            '${val.trxDate.day}-${val.trxDate.month}-${val.trxDate.year}',
                            style: context.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      subtitle: Text("Rp. ${val.ammount.rupiah}"),
                    ),
                  );
                }).toList(),
              );
            }

            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
