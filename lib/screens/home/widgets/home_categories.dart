import 'package:flutter/material.dart';
import 'package:salla/screens/search/search_screen.dart';
import 'package:salla/shared/app/custom_container.dart';
import 'package:salla/shared/app/custom_text.dart';

import '../../category/category_items.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        CategoryItems.routName,
        arguments: text,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: CustomContainer(
           radius: 30,
           color: Colors.grey.withAlpha(33),
           padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
           child: TextWidgets.bodyText(text,fontSize: 11,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
