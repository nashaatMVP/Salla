import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/shared/app/photo_link.dart';
import 'package:smart_shop/shared/theme/app_colors.dart';
import '../../../providers/products_provider.dart';
import '../../../shared/app/custom_container.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    String? productId = ModalRoute.of(context)!.settings.arguments as String?;
    final productsProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productsProvider.findById(productId!);

    return Stack(
      children: [
        CustomContainer(
          width: double.infinity,
          height: 340,
          color: whiteColor,
          padding: const EdgeInsets.symmetric(horizontal: 70 , vertical: 100),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(2, 2),
              ),
            ],
          ),

          child: Image.network(
            path,
          ),
        ),
        Positioned(
            top: 60,
            left: 13,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new,size: 26),
            ),
        ),

        Positioned(
          bottom: 20,
          left: 10,
          child: Card(
            elevation: 7,
            color: blackColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
              child: RatingBarIndicator(
                rating: getCurrentProduct!.productrating!.toDouble(),
                itemBuilder: (context, index) => const Icon(
                  CupertinoIcons.star_fill,
                  color: Colors.yellow,
                ),
                unratedColor: Colors.grey.shade500,
                itemCount: 5,
                itemSize: 13.0,
                direction: Axis.horizontal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
