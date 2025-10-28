import 'package:finmene/utils/extensions/context_extensions.dart';
import 'package:finmene/utils/res/string_res.dart';
import 'package:finmene/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MenuWithMoreBtn extends StatelessWidget {
  const MenuWithMoreBtn({super.key, required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Text(
                  StringRes.moreButton,
                  style: context.textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.blueBrand,
                  ),
                ),
              ),
              Gap(4),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.blueBrand),
            ],
          ),
        ],
      ),
    );
  }
}
