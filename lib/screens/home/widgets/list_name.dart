import 'package:flutter/material.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/theme/app_colors.dart';

class ListName extends StatelessWidget {
  const ListName({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidgets.bodyText1(text,fontSize: 16,fontWeight: FontWeight.w600,color: appColors.primaryColor),
          TextWidgets.bodyText3("View All",fontSize: 14,color: Colors.blue.shade800,fontWeight: FontWeight.bold),
        ],
      ),
    );
  }
}
