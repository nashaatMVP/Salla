import 'package:flutter/material.dart';
class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 4, color: Colors.grey.shade300, thickness: 7);
  }
}
