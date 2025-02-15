import 'package:flutter/material.dart';

/// App Colors
const blackColor = Color(0xFF262626);
const whiteColor = Color(0xFFFFFFFF);
const goldenColor = Color(0xffcfb53b);

const searchBlackColor = Colors.black26;
const primaryLinearColor = [blackColor, blackColor];


@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primaryColor,
    required this.secondaryColor,
    required this.searchColor,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Color searchColor;

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? searchColor,
  }) {
    return AppColors(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      searchColor: searchColor ?? this.searchColor,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
      covariant ThemeExtension<AppColors>? other,
      double t,
      ) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      searchColor: Color.lerp(searchColor, other.searchColor, t)!,
    );
  }

  @override
  String toString() => 'AppColors(primaryColor:$primaryColor, secondaryColor:$secondaryColor)';

  static const light = AppColors(
    primaryColor: blackColor,
    secondaryColor: whiteColor,
    searchColor: whiteColor,
  );

  static const dark = AppColors(
    primaryColor: whiteColor,
    secondaryColor: blackColor,
    searchColor: searchBlackColor,
  );

  static const pink = AppColors(
    primaryColor: blackColor,
    secondaryColor: Color(0xffffcad4),
    searchColor: searchBlackColor,
  );

  static const blue = AppColors(
    primaryColor: Color(0xff005f73),
    secondaryColor: Color(0xffa9def9),
    searchColor: searchBlackColor,
  );

  static const purple = AppColors(
    primaryColor: Color(0xff7b1fa2),
    secondaryColor: Color(0xffe1bee7),
    searchColor: searchBlackColor,
  );
}