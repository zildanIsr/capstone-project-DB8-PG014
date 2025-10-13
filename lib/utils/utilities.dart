import 'package:finmene/utils/enums/snackbar_enum.dart';
import 'package:finmene/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Utilities {
  Utilities._();

  static void showLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Container(
        width: 100,
        height: 100,
        color: AppColors.cardLight,
        child: Center(
          child: LoadingAnimationWidget.discreteCircle(
            color: AppColors.blueBrand, size: 18
          ),
        ),
      )
    );
  }

  static void showSnackbar(BuildContext context, SnackbarEnum type, String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: _snackBarColorbyType(type),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
        ),
      );
  }

  static Color _snackBarColorbyType(SnackbarEnum type) {
    switch (type.name) {
      case "success":
        return AppColors.successFair;
      case "error":
        return AppColors.errorFair;
      case "warning":
        return AppColors.warningFair;
      default:
        return AppColors.errorFair;
    }
  }

}