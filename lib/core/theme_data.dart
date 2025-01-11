import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class Styles {
  static ThemeData themeData(
      {required bool isDarkTheme, required BuildContext context}) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme
          ? AppColors.darkScaffoldColor
          : AppColors.lightScaffoldColor,
      cardColor: isDarkTheme
          ? const Color.fromARGB(255, 0, 0, 0)
          : const Color.fromARGB(255, 255, 255, 255),
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(
        toolbarHeight: 40,
        backgroundColor: isDarkTheme
            ? AppColors.darkScaffoldColor
            : AppColors.lightScaffoldColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemStatusBarContrastEnforced: true,
          statusBarColor: isDarkTheme
              ? AppColors.darkScaffoldColor
              : AppColors.lightScaffoldColor,
          systemNavigationBarColor: isDarkTheme
              ? Colors.white
              : Colors.black,
        ),

        titleTextStyle: TextStyle(
          color: isDarkTheme ? Colors.white : const Color(0xffCBB26A),
        ),
        iconTheme:
            IconThemeData(color: isDarkTheme ? Colors.white : Colors.black),
      ),
    );
  }
}
