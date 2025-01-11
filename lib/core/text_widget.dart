import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class AppNameTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? baseColor;
  final Color? highColor;

  const AppNameTextWidget({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    this.baseColor = Colors.black,
    this.highColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      // ignore: sort_child_properties_last
      child: Text(
        text,
        style: GoogleFonts.alike(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      baseColor: baseColor!,
      highlightColor: highColor!,
      period: const Duration(milliseconds: 2000),
    );
  }
}


class TitlesTextWidget extends StatelessWidget {
  const TitlesTextWidget({
    Key? key,
    required this.label,
    this.fontSize = 20,
    this.color,
    this.maxLines,
    this.fontWeight,
  }) : super(key: key);

  final String label;
  final double fontSize;
  final Color? color;
  final int? maxLines;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.alike(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decorationThickness: 0,
      ),
    );
  }
}


class SubtitleTextWidget extends StatelessWidget {
  const SubtitleTextWidget({
    super.key,
    required this.label,
    this.fontSize = 18,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textDecoration = TextDecoration.none,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
  });

  final String label;
  final double fontSize;
  final FontStyle fontStyle;
  final FontWeight? fontWeight;
  final Color? color;
  final TextDecoration textDecoration;
  final TextOverflow overflow;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.alike(
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration,
        color: color,
        fontStyle: fontStyle,
      ),
    );
  }
}
