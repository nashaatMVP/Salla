import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_shop/shared/constants.dart';
import 'package:smart_shop/shared/custom_text.dart';
import '../screens/search_screen.dart';
import '../shared/theme/app_colors.dart';

class CategoryRoundedWidget extends StatelessWidget {
  const CategoryRoundedWidget({
    super.key,
    required this.image,
    required this.name,
  });

  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          SearchScreen.routName,
          arguments: name,
        );
      },
      child: Column(
        children: [
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(400),
            shadowColor: Colors.grey.shade50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.lightGreen.shade100,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  image,
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),
          Gap(5),
          TextWidgets.bodyText1(name,fontWeight: FontWeight.w600,color: appColors.primaryColor,fontSize: 10),
        ],
      ),
    );
  }
}


class CategorySearchWidget extends StatelessWidget {
  const CategorySearchWidget({
    super.key,
    required this.name,
  });
  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          SearchScreen.routName,
          arguments: name,
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200, width: 2),
                color: Colors.grey.shade100,
              ),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
