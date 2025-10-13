import 'package:finmene/utils/enums/button_size_type_enum.dart';
import 'package:finmene/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ButtonOutlined extends StatelessWidget {
  final String title;
  final ButtonSizeType sizeType;
  final EdgeInsets? margin;
  final double? borderRadius;
  final double? width;
  final IconData? leadingIcon;
  final IconData? suffixIcon;
  final bool disabled;
  final Function()? onPressed;
  final Color? customPrimaryColor;

  const ButtonOutlined(
      {super.key,
      required this.title,
      this.sizeType = ButtonSizeType.MEDIUM,
      this.margin,
      this.borderRadius,
      this.width,
      this.leadingIcon,
      this.suffixIcon,
      this.disabled = false,
      this.onPressed,
      this.customPrimaryColor});

  @override
  Widget build(BuildContext context) {
    Color buttonColor = AppColors.transparent;
    Color componentColor = customPrimaryColor ?? AppColors.primary;

    return Container(
        margin: margin ?? EdgeInsets.zero,
        child: FilledButton(
            onPressed: disabled ? null : onPressed,
            style: ButtonStyle(
                minimumSize: WidgetStatePropertyAll<Size>(width != null
                    ? Size(width!, getHeight())
                    : Size.fromHeight(getHeight())),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  side: BorderSide(color: componentColor),
                  borderRadius: BorderRadius.circular(borderRadius ?? 24),
                )),
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return buttonColor;
                  }
                  if (states.contains(WidgetState.focused)) {
                    return buttonColor;
                  }
                  if (states.contains(WidgetState.selected)) {
                    return buttonColor;
                  }
                  if (states.contains(WidgetState.disabled)) {
                    return AppColors.whiteRoot;
                  }

                  return buttonColor;
                }),
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: 14, horizontal: 32))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              leadingIcon != null
                  ? Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Icon(
                        leadingIcon,
                        color: componentColor,
                        size: getIconSize(),
                      ),
                    )
                  : Container(),
              Text(
                title,
                style: getTextStyle(context, componentColor).copyWith(height: 0),
              ),
              suffixIcon != null
                  ? Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Icon(
                        suffixIcon,
                        color: componentColor,
                        size: getIconSize(),
                      ),
                    )
                  : Container(),
            ])));
  }

  TextStyle getTextStyle(BuildContext context, Color fontColor){
    switch(sizeType){
      case ButtonSizeType.LARGE:
        return Theme.of(context).textTheme.titleMedium!.copyWith(color: fontColor);
      case ButtonSizeType.NORMAL:
        return Theme.of(context).textTheme.titleMedium!.copyWith(color: fontColor);
      case ButtonSizeType.MEDIUM:
        return Theme.of(context).textTheme.titleMedium!.copyWith(color: fontColor);
      case ButtonSizeType.SMALL:
        return Theme.of(context).textTheme.titleSmall!.copyWith(color: fontColor);
      case ButtonSizeType.EXTRA_SMALL:
        return Theme.of(context).textTheme.titleSmall!.copyWith(color: fontColor);
    }
  }

  double getIconSize() {
    switch (sizeType) {
      case ButtonSizeType.LARGE:
      case ButtonSizeType.NORMAL:
      case ButtonSizeType.MEDIUM:
        return 24;
      case ButtonSizeType.SMALL:
      case ButtonSizeType.EXTRA_SMALL:
        return 16;
    }
  }

  double getHeight() {
    switch (sizeType) {
      case ButtonSizeType.LARGE:
        return 64;
      case ButtonSizeType.NORMAL:
        return 56;
      case ButtonSizeType.MEDIUM:
        return 52;
      case ButtonSizeType.SMALL:
        return 40;
      case ButtonSizeType.EXTRA_SMALL:
        return 32;
    }
  }
}
