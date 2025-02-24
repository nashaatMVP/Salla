import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    this.height,
    this.shadows,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.decoration,
    this.wordSpacing,
    required this.text,
    this.letterSpacing,
    this.fontSize = 14,
    this.canTrans = true,
    this.color,
    this.decorationThickness = 2,
    this.fontWeight = FontWeight.w400,
  });
  final String text;
  final Color? color;
  final bool canTrans;
  final int? maxLines;
  final double? height;
  final double fontSize;
  final double? wordSpacing;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final FontWeight fontWeight;
  final List<Shadow>? shadows;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double decorationThickness;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontFamily: 'IBMPlexSans',
        height: height,
        shadows: shadows,
        fontSize: fontSize,
        decoration: decoration,
        fontWeight: fontWeight,
        decorationColor: color,
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
        decorationThickness: decorationThickness,
      ),
    );
  }
}

///-------- TEXT WIDGETS --------///

class TextWidgets {
  static Widget heading(
      String text, {
        Color? color,
        double? fontSize,
        FontWeight? fontWeight,
      }) {
    return CustomText(
      text: text,
      fontSize: fontSize ?? 22,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color ?? Colors.white,
    );
  }

  static Widget subHeading(
      String text, {
        Color? color,
        double? fontSize,
        TextAlign? textAlign,
        FontWeight? fontWeight,
        int? maxLines,
      }) {
    return CustomText(
      text: text,
      color: color,
      fontSize: fontSize ?? 20,
      fontWeight: fontWeight ?? FontWeight.w700,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  /// font-family: IBM Plex Sans;
  /// font-size: 12px;
  /// font-weight: 500;
  /// line-height: 15.6px;
  /// text-align: left;
  static Widget bodyText(
      String text, {
        Color? color,
        double? fontSize,
        FontWeight? fontWeight,
        TextAlign? textAlign,
        double? letterSpacing,
        int? maxLines,
      }) {
    return CustomText(
      text: text,
      color: color,
      fontSize: fontSize ?? 12,
      fontWeight: fontWeight ?? FontWeight.w500,
      textAlign: textAlign,
      letterSpacing: letterSpacing,
      maxLines: maxLines,
    );
  }

  static Widget bodyText1(
      String text, {
        Color? color,
        double? fontSize,
        FontWeight? fontWeight,
        TextAlign? textAlign,
        double? letterSpacing,
        double? lineHeight,
        TextDecoration? decoration,
        TextOverflow? overflow,
        int? maxLines,
      }) {
    return CustomText(
      text: text,
      color: color,
      fontSize: fontSize ?? 12,
      fontWeight: fontWeight ?? FontWeight.w400,
      textAlign: textAlign,
      letterSpacing: letterSpacing,
      height: lineHeight,
      decoration: decoration,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  static Widget errorText(
      String text, {
        Color? color,
        double? fontSize,
        FontWeight? fontWeight,
      }) {
    return CustomText(
      text: text,
      color: color,
      fontSize: fontSize ?? 12,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  static Widget bodyText2(
      String text, {
        Color? color,
        double? fontSize,
        FontWeight? fontWeight,
        TextAlign? textAlign,
      }) {
    return CustomText(
      text: text,
      color: color,
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.w400,
      textAlign: textAlign,
    );
  }

  static Widget bodyText3(
      String text, {
        Color? color,
        double? fontSize,
        FontWeight? fontWeight,
      }) {
    return CustomText(
      text: text,
      color: color,
      fontSize: fontSize ?? 10,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  static Widget richText(
      {required String text1,
        required String text2,
        required FontWeight weight1,
        required FontWeight weight2,
        required double size1,
        required double size2,
        Color? color2,
        Color? color1,
        double? letterSpacing1,
        double? letterSpacing2}) {
    return RichText(
        text: TextSpan(children: [
          TextSpan(
              text: text1,
              style: TextStyle(
                  fontWeight: weight1,
                  fontSize: size1,
                  color: color1,
                  letterSpacing: letterSpacing1)),

          TextSpan(
              text: text2,
              style: TextStyle(
                  fontWeight: weight2,
                  fontSize: size2,
                  color: color2,
                  letterSpacing: letterSpacing2))
        ]));
  }
}