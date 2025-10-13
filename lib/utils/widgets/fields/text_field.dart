import 'package:finmene/utils/extensions/context_extensions.dart';
import 'package:finmene/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegularTextFormField extends StatefulWidget {
  const RegularTextFormField({
    super.key,
    this.textFormFieldKey,
    required this.controller,
    this.label,
    this.autoValidateMode,
    this.hint,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.obscureText,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.prefix,
    this.showErrorText = true,
    this.validator,
    this.successInfo,
    this.keyboardType,
    this.inputFormatter,
    this.enableInteractiveSelection,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.inputAction,
    this.forceSelectBorder = false,
    this.showClearIcon = true,
    this.textAlign = TextAlign.start,
    this.contentPadding,
    this.customTextStyle,
    this.isChangeOnInput = true,
    this.hintText,
    this.hintStyle,
    this.prefixIconConstraints,
    this.useBorder = true,
    this.autoFocus = false,
    this.borderValidColor,
    this.hintPadding,
    this.customEmptySuffixEvent,
    this.onEditingComplete,
    this.onTapOutside,
  });

  final FocusNode? focusNode;
  final Key? textFormFieldKey;
  final AutovalidateMode? autoValidateMode;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? successInfo;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool? obscureText;
  final ValueChanged<String>? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final bool showErrorText;
  final Widget? suffixIcon, prefixIcon, prefix;
  final bool? enableInteractiveSelection;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatter;
  final TextCapitalization textCapitalization;
  final bool forceSelectBorder;
  final bool showClearIcon;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? customTextStyle;
  final bool isChangeOnInput;
  final String? hintText;
  final TextStyle? hintStyle;
  final BoxConstraints? prefixIconConstraints;
  final bool useBorder;
  final Color? borderValidColor;
  final EdgeInsets? hintPadding;
  final bool autoFocus;
  final Function()? customEmptySuffixEvent;
  final VoidCallback? onEditingComplete;
  final TapRegionCallback? onTapOutside;

  @override
  State<RegularTextFormField> createState() => _RegularTextFormFieldState();
}

class _RegularTextFormFieldState extends State<RegularTextFormField> {
  String _value = '';
  bool _isInvalidValue = false;
  late final FocusNode _textFieldFocus;
  bool _isEmpty = true;

  //Color _bgColor = Colors.white;

  @override
  void initState() {
    _textFieldFocus = widget.focusNode ?? FocusNode();
    super.initState();
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          _isEmpty = widget.controller.text.isEmpty;
        });
      }
    });
    if (widget.controller.text.isNotEmpty) {
      _isEmpty = false;
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _textFieldFocus.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          autofocus: widget.autoFocus,
          textAlign: widget.textAlign,
          textInputAction: widget.inputAction,
          textCapitalization: widget.textCapitalization,
          focusNode: _textFieldFocus,
          autovalidateMode: widget.autoValidateMode,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          inputFormatters: widget.inputFormatter,
          maxLength: widget.maxLength,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle:
                widget.hintStyle ??
                context.textTheme.labelMedium!.copyWith(
                  color: AppColors.whiteFair,
                ),
            contentPadding: widget.contentPadding,
            labelText: widget.label,
            labelStyle: _isInvalidValue && widget.showErrorText
                ? context.textTheme.bodyMedium!.copyWith(
                    color: AppColors.errorFair,
                  )
                : context.textTheme.bodyMedium!.copyWith(
                    color: AppColors.blackSoft,
                  ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            floatingLabelStyle: context.textTheme.labelMedium!.copyWith(
              color: _isInvalidValue && widget.showErrorText
                  ? AppColors.errorFair
                  : AppColors.blackSoft,
            ),
            border: widget.useBorder
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEmpty
                          ? AppColors.whiteSoft
                          : widget.borderValidColor ?? AppColors.primary,
                      width: 1,
                    ),
                  )
                : InputBorder.none,
            enabledBorder: widget.useBorder
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEmpty
                          ? AppColors.whiteSoft
                          : widget.borderValidColor ?? AppColors.primary,
                      width: 1,
                    ),
                  )
                : InputBorder.none,
            focusedBorder: widget.useBorder
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.borderValidColor ?? AppColors.primary,
                      width: 1,
                    ),
                  )
                : InputBorder.none,
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.errorFair, width: 1),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.errorFair, width: 1),
            ),
            errorStyle: const TextStyle(
              height: 0.01,
              color: Colors.transparent,
              fontSize: 0,
            ),
            focusColor: AppColors.whiteHeavy,
            hoverColor: AppColors.whiteHeavy,
            filled: true,
            fillColor: _isEmpty
                ? AppColors.whiteMassive
                : widget.isChangeOnInput
                ? AppColors.whiteHeavy
                : AppColors.whiteMassive,
            suffixIcon:
                widget.suffixIcon ??
                (widget.showClearIcon && !_isEmpty
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 16,
                        icon: const Icon(
                          Icons.cancel,
                          color: AppColors.blackFair,
                          size: 16,
                        ),
                        onPressed: () => {
                          widget.controller.clear(),
                          setState(() {
                            _isEmpty = true;
                          }),
                          if (widget.customEmptySuffixEvent != null)
                            {widget.customEmptySuffixEvent!()},
                        },
                      )
                    : null),
            prefixIcon: widget.prefixIcon,
            prefixIconConstraints: widget.prefixIconConstraints,
            prefix: widget.prefix,
            counterText: '',
          ),
          key: widget.textFormFieldKey,
          minLines: widget.minLines,
          maxLines: widget.minLines != null
              ? widget.maxLines
              : widget.maxLines ?? 1,
          obscureText: widget.obscureText ?? false,
          onChanged: (value) {
            widget.onChanged?.call(value);
            setState(() {
              _value = value;
              _isInvalidValue = widget.validator?.call(_value) != null;
              _isEmpty = value.isEmpty;
            });
          },
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          style:
              widget.customTextStyle ??
              context.textTheme.bodyMedium!.copyWith(
                color: AppColors.blackFair,
              ),
          cursorErrorColor: AppColors.blackFair,
          validator: (value) {
            final validation = widget.validator?.call(_value);
            _isInvalidValue = validation != null;
            return validation;
          },
          onEditingComplete: widget.onEditingComplete,
          onTapOutside: widget.onTapOutside,
        ),
        const SizedBox(height: 4),
        widget.hint != null && widget.hint!.isNotEmpty
            ? Padding(
                padding:
                    widget.hintPadding ??
                    const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  widget.hint!,
                  style: context.textTheme.labelMedium!.copyWith(
                    color: AppColors.blackSoft,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        Visibility(
          visible: widget.successInfo != null && !_isInvalidValue,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1.0),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.successFair,
                  size: 16,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.successInfo ?? '',
                  style: context.textTheme.labelMedium!.copyWith(
                    color: AppColors.successFair,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _isInvalidValue && widget.showErrorText,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.validator?.call(_value) ?? '',
                  style: context.textTheme.labelMedium!.copyWith(
                    color: AppColors.errorFair,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
