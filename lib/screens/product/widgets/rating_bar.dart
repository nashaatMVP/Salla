import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_shop/shared/app/custom_container.dart';
import '../../../shared/app/constants.dart';
import '../../../shared/app/custom_text.dart';
import '../../../shared/theme/app_colors.dart';


class RatingBarCard extends StatelessWidget {
  const RatingBarCard({super.key, required this.image, required this.titleReview, required this.subTitleReview, required this.ratingNumber});
  final String image, titleReview , subTitleReview , ratingNumber;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return CustomContainer(
      width: double.infinity,
      color: appColors.secondaryColor,
      borderColor: Colors.grey,
      radius: 7,
      padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
            NetworkImage(
              image,
            ),
            radius: 20,
          ),
          kGap10,
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              TextWidgets.subHeading(titleReview,fontSize: 13, color: appColors.primaryColor,fontWeight: FontWeight.w600),
              SizedBox(
                  width: 200,
                  child: TextWidgets.bodyText(subTitleReview, color: appColors.primaryColor)),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              TextWidgets.bodyText("${double.parse(ratingNumber)}" , color: appColors.primaryColor),
              kGap10,
              const Icon(
                CupertinoIcons.star_fill,
                color: Colors.green,
                size: 16,
              ),
              kGap10,
            ],
          ),
        ],
      ),
    );
  }
}
