import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../shared/app/constants.dart';
import '../../../shared/app/custom_container.dart';
import '../../../shared/app/custom_text.dart';
import '../../../shared/theme/app_colors.dart';
import '../AddAddressScreen.dart';
import '../saved_address_screen.dart';

class AddNewAddressCard extends StatelessWidget {
  const AddNewAddressCard({super.key,required this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: CustomContainer(
          radius: 12,
          height: 50,
          borderColor: greenColor,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: CustomContainer(
              radius: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Icon(
                  //   size: 20,
                  //   Ionicons.add,
                  //   color: greenColor,
                  // ),
                  // kGap10,
                  TextWidgets.subHeading("Add Address",color: appColors.primaryColor,fontSize: 13),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
