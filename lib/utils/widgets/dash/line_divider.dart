import 'package:finmene/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LineDivider extends StatelessWidget {
  const LineDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.blackRoot,
      indent: 16,
      endIndent: 16,
    );
  }
}