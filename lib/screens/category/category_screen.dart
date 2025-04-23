import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../core/app_constans.dart';
import '../../shared/app/custom_text.dart';
import 'category_items.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECECEC),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(70),
            TextWidgets.bodyText1("Categories", fontWeight: FontWeight.bold, fontSize: 20),
            const Gap(10),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: AppConsts.categoryList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final category = AppConsts.categoryList[index];

                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      CategoryItems.routName,
                      arguments: AppConsts.categoryList[index].name,
                    ),

                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Colors.white60,
                          Colors.white38,
                        ]),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            category.image,
                            width: 80,
                            height: 80,
                          ),
                          const SizedBox(height: 20),
                          TextWidgets.bodyText1(
                            category.name,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
