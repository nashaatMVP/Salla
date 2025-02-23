import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_shop/shared/app/photo_link.dart';
import 'package:smart_shop/shared/theme/app_colors.dart';
import '../../../shared/app/custom_container.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomContainer(
          width: double.infinity,
          height: 400,
          color: whiteColor,
          padding: const EdgeInsets.symmetric(horizontal: 70 , vertical: 100),
          child: Image.network(
            path,
          ),
        ),
        Positioned(
            top: 70,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(PhotoLink.backButtonLink,width: 30)),
        ),
      ],
    );
  }
}
