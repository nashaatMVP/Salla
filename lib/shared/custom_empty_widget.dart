import 'package:flutter/material.dart';
import 'package:smart_shop/root_screen.dart';
import 'custom_text.dart';
import 'theme/app_colors.dart';

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
            TextWidgets.bodyText1(
        title,
              // color: Colors.black,
              fontSize: 15,
            ),
            const SizedBox(
              height: 10,
            ),
            TextWidgets.bodyText1(
          subTitle,
            ),
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              image,
              height: 140,
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.primaryColor

                ),
                onPressed: () {
                  Navigator.pushNamed(context, RootScreen.routeName);
                },
                child: Text(
                  buttonTitle,
                  style: TextStyle(
                    fontSize: 15,
                    color: appColors.primaryColor
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
