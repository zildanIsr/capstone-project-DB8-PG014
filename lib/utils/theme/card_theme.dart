import 'package:finmene/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CardThemeCustom {
  CardThemeCustom._();

  static CardThemeData get cardThemeLight => 
    CardThemeData(
      color: AppColors.whiteHeavy,
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16).copyWith(top: 0),      
    );

  static CardThemeData get cardThemeDark => 
    CardThemeData(
      color: AppColors.blackHeavy,
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16).copyWith(top: 0),
    );
}