import 'package:flutter/material.dart';
import 'package:salla/shared/app/custom_button.dart';
import 'package:salla/shared/app/custom_text.dart';
import '../../../shared/app/constants.dart';
import '../../../shared/theme/app_colors.dart';
import '../../auth/login.dart' show LoginScreen;
import '../../auth/register.dart' show RegisterScreen;


class GuestWidget extends StatelessWidget {
  const GuestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          kGap40,
          CustomButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => const LoginScreen()))),
              text: "Login",
              arrow: true,
              backgroundColor: appColors.primaryColor,
              textColor: appColors.secondaryColor,

          ),
          kGap20,
          TextWidgets.subHeading("OR" , color: appColors.primaryColor),
          kGap20,
          CustomButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>
                    const RegisterScreen()))),
            text: "Sign up",
            arrow: true,
            backgroundColor: appColors.primaryColor,
            textColor: appColors.secondaryColor,
          ),
          kGap100,
        ],
      ),
    );
  }
}
