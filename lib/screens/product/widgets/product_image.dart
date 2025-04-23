import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:salla/shared/theme/app_colors.dart';
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
          height: 200,
          color: whiteColor,
          padding: const EdgeInsets.symmetric(horizontal: 30 , vertical: 20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
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
            top: 20,
            left: 13,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back,size: 26),
            ),
        ),
      ],
    );
  }
}
