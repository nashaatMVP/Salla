import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../shared/app/constants.dart';
import '../../../shared/app/custom_text.dart';
import '../../../shared/theme/app_colors.dart';

class SocialMediaCard extends StatelessWidget {
  const SocialMediaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return  Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        /// logos
        Center(
          child: SizedBox(
            width: 140,
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Ionicons.logo_instagram,
                  color: Color(0xffC13584),
                ),
                const Icon(
                  Ionicons.logo_facebook,
                  color: Color(0xff4267B2),
                ),
                Icon(
                  Ionicons.logo_tiktok,
                  color: appColors.primaryColor,
                ),
              ],
            ),
          ),
        ),
        kGap20,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidgets.bodyText1("Terms of us",color: appColors.primaryColor),
            kGap10,
            TextWidgets.bodyText1("Terms of sale",color: appColors.primaryColor),
            kGap10,

            TextWidgets.bodyText1("Privacy Policy",color: appColors.primaryColor),
          ],
        ),
        kGap10,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.copyright,
              size: 12,
              color: Colors.grey,
            ),
            kGap5,
            TextWidgets.bodyText1("2023 salla.com All rights reversed.",color: appColors.primaryColor),
          ],
        ),
        kGap30,
      ],
    );
  }
}
