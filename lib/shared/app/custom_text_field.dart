import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ignore: must_be_immutable
class CustomFormField extends StatelessWidget {
  CustomFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintName,
    required this.iconData,
    required this.onFieldSubmitted,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    required this.obscureText,
    this.textInputAction,
    this.icon,
    this.label,
    this.maxLines = 1,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintName;
  final IconData iconData;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? icon;
  final void Function(String)? onFieldSubmitted;
  String? Function(String?)? validator;
  final String? label;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return SizedBox(
      height: 40,
      child: TextFormField(
        autocorrect: true,
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        cursorHeight: 10,
        cursorColor: blueColor,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: 15,
          decorationThickness: 0,
          fontWeight: FontWeight.w500,
          color: appColors.primaryColor,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide:  BorderSide(color: Colors.green.shade700),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide:  BorderSide(color: Colors.grey.shade200),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.purple),
          ),
          fillColor: appColors.secondaryColor,
          filled: true,
          hintText: hintName,
          hintStyle: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.bold,
          ),
          icon: icon,
          suffixIcon: suffixIcon,
          prefixIcon: Icon(
            iconData,
            size: 17,
            color: appColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
