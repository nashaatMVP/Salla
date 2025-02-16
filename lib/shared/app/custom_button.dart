import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_shop/shared/theme/theme_data.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final bool isLoading;
  final Color backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool arrow;
  final Color? borderColor;
  final double? letterSpacing;
  final EdgeInsetsGeometry? padding;
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.isLoading = false,
    required this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.arrow = false,
    this.borderColor,
    this.letterSpacing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
              side: borderColor != null
                  ? BorderSide(color: borderColor ?? Colors.transparent)
                  : BorderSide.none),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: isLoading
                    ? const CupertinoActivityIndicator(color: Colors.white)
                    : TextWidgets.bodyText(
                  text,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  letterSpacing: letterSpacing,
                ),
              ),
            ),
            if (arrow) ...{
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            }
          ],
        ),
      ),
    );
  }
}

class CustomButton2 extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;

  const CustomButton2({
    super.key,
    required this.text,
    this.onPressed,
    this.width = double.maxFinite,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).extension<AppTheme>();
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}