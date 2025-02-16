import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../shared/app/constants.dart';
import '../../../shared/app/custom_container.dart';
import '../../../shared/app/custom_text.dart';
import '../../../shared/theme/app_colors.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({super.key, required this.svg, required this.text, this.function,  this.size = 20});
  final String svg , text;
  final double size ;
  final void Function()? function;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: function,
      child: CustomContainer(
       color: appColors.secondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 14),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(svg , width: size ,color: appColors.primaryColor),
                kGap10,
                TextWidgets.bodyText1(text,fontWeight: FontWeight.w700,fontSize: 15 , color: appColors.primaryColor),
                const Spacer(),
                Icon(Icons.arrow_forward_ios,color: appColors.primaryColor),
              ],
            ),
            kGap15,
            const Divider(color: Colors.grey,thickness: 1.5),
          ],
        ),
      ),
    );
  }
}
