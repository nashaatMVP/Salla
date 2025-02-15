import 'package:flutter/material.dart';
import 'package:smart_shop/screens/search_screen.dart';
import 'package:smart_shop/shared/custom_container.dart';
import 'package:smart_shop/shared/custom_text.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        SearchScreen.routName,
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
