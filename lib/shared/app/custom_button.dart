import 'package:flutter/material.dart';
import 'package:smart_shop/shared/app/custom_container.dart';
import '../theme/app_colors.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final bool isLoading;
  final Color backgroundColor;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool arrow;
  final Color? borderColor;
  final double? letterSpacing;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final Color? arrowColor;
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height = 45,
    this.isLoading = false,
    required this.backgroundColor,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.arrow = false,
    this.borderColor,
    this.letterSpacing,
    this.padding,
    this.textColor,
    this.arrowColor,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: onPressed,
      child: CustomContainer(
        width: width ,
        height: height,
        borderColor: borderColor,
        radius: borderRadius ?? 9,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
        color: backgroundColor ?? appColors.primaryColor,
        child: Row(
          mainAxisAlignment: arrow == true ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(arrow)...[
              const SizedBox.shrink(),
            ],

            TextWidgets.subHeading(text , fontWeight: fontWeight,fontSize: fontSize ?? 15,color: textColor),

            if(arrow)...[
              Icon(Icons.arrow_forward,color: arrowColor ?? appColors.secondaryColor),
            ]

          ],
        ),
      ),
    );
  }
}

