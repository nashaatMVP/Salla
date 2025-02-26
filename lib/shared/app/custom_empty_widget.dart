import 'package:flutter/material.dart';
import 'package:smart_shop/shared/app/photo_link.dart';
import 'constants.dart';
import 'custom_button.dart';
import 'custom_text.dart';
import '../theme/app_colors.dart';

class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.buttonTitle,
    required this.isCart,
  });

  final String title, subTitle, buttonTitle;
  final bool isCart;

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
              isCart ? PhotoLink.emptyCart : PhotoLink.emptyOrder,
              height: 140,
            ),
            kGap30,
            Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20.0),
             child: CustomButton(
                 text: "Go To Shopping",
                 textColor: appColors.secondaryColor,
                 backgroundColor: appColors.primaryColor,
                 arrowColor: appColors.secondaryColor,
                 fontWeight: FontWeight.bold,
                 arrow: true,
             ),
           ),
          ],
        ),
      ),
    );
  }
}
