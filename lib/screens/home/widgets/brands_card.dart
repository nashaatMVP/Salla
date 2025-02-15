import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/app_constans.dart';
import '../../../shared/custom_container.dart';

class BrandsCard extends StatelessWidget {
  const BrandsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  CustomContainer(
      color: Colors.grey.shade300,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            spacing: 20,
            children: List.generate(AppConsts.brandSvgs.length, (index) => SvgPicture.asset(AppConsts.brandSvgs[index],width: 30)),
          ),
        ),
      ),
    );
  }
}
