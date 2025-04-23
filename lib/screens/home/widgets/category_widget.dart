import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:salla/shared/app/custom_text.dart';
import '../../../core/app_constans.dart';
import '../../category/category_items.dart';
import '../../search/search_screen.dart';
import '../../../shared/theme/app_colors.dart';

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
      onTap: () => Navigator.pushNamed(
        context,
        CategoryItems.routName,
        arguments: name,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(300),
                child: Image.asset(
                  image,
                  width: 60,
                  height: 69,
                ),
              ),
            ),
          ),
          const Gap(15),
          TextWidgets.bodyText1(name,fontWeight: FontWeight.w600,color: appColors.primaryColor,fontSize: 10),
        ],
      ),
    );
  }
}
