import 'package:finmene/utils/enums/snackbar_enum.dart';
import 'package:finmene/utils/res/string_res.dart';
import 'package:finmene/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';

class Utilities {
  Utilities._();

  static void showLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha((0.4 * 255).round()),
      builder: (_) => Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: AppColors.blueBrand,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  static void showSnackbar(
    BuildContext context,
    SnackbarEnum type,
    String? message,
  ) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message ?? StringRes.defaultErrorMessage,
            style: Theme.of(context).textTheme.bodyMedium,
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

  static Widget shimmerPlaceholder() {
    return SizedBox(
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: AppColors.blackSoft,
        highlightColor: AppColors.blackRoot,
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            width: 45,
            height: 45,
          ),
          title: Container(
            width: double.infinity,
            height: 16,
            color: Colors.white,
          ),
          subtitle: Container(width: 200, height: 14, color: Colors.white),
        ),
      ),
    );
  }
}
