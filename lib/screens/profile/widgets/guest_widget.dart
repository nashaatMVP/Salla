import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_shop/shared/app/custom_button.dart';
import 'package:smart_shop/shared/app/custom_text.dart';
import '../../../AUTH/login.dart';
import '../../../AUTH/register.dart';
import '../../../shared/app/constants.dart';
import '../../../shared/theme/app_colors.dart';


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
                    builder: ((context) =>
                    const RegisterScreen()))),
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
