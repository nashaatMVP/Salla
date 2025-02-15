import 'app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTheme {
  AppTheme._();

  // LIGHT THEME
  static final ThemeData light = ThemeData(
    extensions:  const <ThemeExtension<AppColors>>[
      AppColors.light,
    ],
    useMaterial3: false,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      titleTextStyle: TextStyle(color: blackColor),
      iconTheme: IconThemeData(color: blackColor),
      actionsIconTheme: IconThemeData(color: blackColor),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: whiteColor,
        systemNavigationBarColor: whiteColor,
        systemNavigationBarDividerColor: whiteColor,
        systemStatusBarContrastEnforced: false,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: whiteColor),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: whiteColor,
      surfaceTintColor: whiteColor,
    ),
    bottomSheetTheme: const BottomSheetThemeData(surfaceTintColor: whiteColor),
    textTheme: GoogleFonts.montserratTextTheme(),
    primaryColor: whiteColor,
    scaffoldBackgroundColor: whiteColor,
  );

  //  DARK THEME
  static final ThemeData dark = ThemeData(
    extensions:  const <ThemeExtension<AppColors>>[
      AppColors.dark,
    ],
    primaryTextTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
    canvasColor: blackColor,
    colorScheme: ColorScheme.fromSeed(seedColor: blackColor),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: blackColor,
      surfaceTintColor: blackColor,
      shadowColor: whiteColor,
    ),
    bottomSheetTheme: const BottomSheetThemeData(surfaceTintColor: blackColor),
    textTheme: GoogleFonts.montserratTextTheme(),
    primaryColor: blackColor,
    scaffoldBackgroundColor: Colors.grey.withAlpha(200).withOpacity(0.4),
    appBarTheme: const AppBarTheme(
      backgroundColor: blackColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: whiteColor,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: blackColor,
        systemNavigationBarColor: blackColor,
        systemNavigationBarDividerColor: blackColor,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      iconTheme: IconThemeData(color: whiteColor),
      surfaceTintColor: whiteColor,
    ),
  );

  // PINK THEME
  static final ThemeData pink = ThemeData(
    extensions: const <ThemeExtension<AppColors>>[
      AppColors.pink,
    ],
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffffcad4),
      elevation: 0,
      titleTextStyle: TextStyle(color: blackColor),
      iconTheme: IconThemeData(color: blackColor),
      actionsIconTheme: IconThemeData(color: blackColor),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xfff4acb7)),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Color(0xfff4acb7),
      surfaceTintColor: whiteColor,
    ),
    bottomSheetTheme:
    const BottomSheetThemeData(surfaceTintColor: Color(0xfff4acb7)),
    textTheme: GoogleFonts.montserratTextTheme(),
    primaryColor: blackColor,
    scaffoldBackgroundColor: const Color(0xffffcad4),
  );

  // BLUE THEME
  static final ThemeData blue = ThemeData(
    extensions: const <ThemeExtension<AppColors>>[
      AppColors.blue,
    ],
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      titleTextStyle: TextStyle(color: blackColor),
      iconTheme: IconThemeData(color: Color(0xffa9def9)),
      actionsIconTheme: IconThemeData(color: Color(0xffa9def9)),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: whiteColor),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: whiteColor,
      surfaceTintColor: whiteColor,
    ),
    bottomSheetTheme: const BottomSheetThemeData(surfaceTintColor: Color(0xffa9def9)),
    textTheme: GoogleFonts.montserratTextTheme(),
    primaryColor: blackColor,
    scaffoldBackgroundColor: whiteColor,
  );

  // Purple THEME
  static final ThemeData purple = ThemeData(
    extensions: const <ThemeExtension<AppColors>>[
      AppColors.purple,
    ],
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff9b59b6), // A purple color for the app bar
      elevation: 0,
      titleTextStyle:
      TextStyle(color: Colors.white), // Adjust text color for contrast
      iconTheme:
      IconThemeData(color: Colors.white), // Adjust icon color for contrast
      actionsIconTheme:
      IconThemeData(color: Colors.white), // Adjust actions icon color
    ),
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff8e44ad)), // Seed color for purple
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Color(0xff8e44ad), // Matching the bottom app bar color
      surfaceTintColor: whiteColor,
    ),
    bottomSheetTheme:
    const BottomSheetThemeData(surfaceTintColor: Color(0xff8e44ad)),
    textTheme: GoogleFonts.montserratTextTheme(),
    primaryColor: Colors.deepPurple, // Use a deep purple for primary color
    scaffoldBackgroundColor:
    const Color(0xfff3e5f5), // A light purple for the background
  );
}
