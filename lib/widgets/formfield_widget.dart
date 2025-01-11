import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomFormField extends StatelessWidget {
  CustomFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintName,
    required this.iconData,
    required this.onFieldSubmitted,
    required this.validator,
    this.suffixIcon,
    required this.keyboardType,
    required this.obscureText,
    this.textInputAction,
    this.icon,
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: TextFormField(
        autocorrect: true,
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 15,
          decorationThickness: 0,
          color: Colors.black,
        ),
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.purple),
          ),
          errorText: 'Must be Filled',
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),

          fillColor: Colors.white,
          filled: true,
          hintText: hintName,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          icon: icon,
          suffixIcon: suffixIcon,
          prefixIcon: Icon(
            iconData,
            color: Colors.grey,
          ),
        ),
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
      ),
    );
  }
}
