import 'package:flutter/material.dart';
import 'constants.dart';
import 'custom_button.dart';
import 'custom_text.dart';
import '../theme/app_colors.dart';

class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.buttonTitle,
  });

  final String image, title, subTitle, buttonTitle;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidgets.heading(
               title,
              fontSize: 18,
              color: appColors.primaryColor
            ),
            kGap10,
            TextWidgets.subHeading(
             subTitle,
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
            kGap30,

            Image.asset(
              image,
              height: 140,
            ),
            kGap30,
           const Padding(
             padding: EdgeInsets.symmetric(horizontal: 20.0),
             child: CustomButton(text: "Go To Shopping", backgroundColor: Colors.black),
           ),
          ],
        ),
      ),
    );
  }
}
