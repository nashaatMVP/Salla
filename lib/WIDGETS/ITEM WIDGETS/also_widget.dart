import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/MODELS/product_model.dart';
import 'package:smart_shop/SIDE%20SCREENS/product_datails_screen.dart';
import 'package:smart_shop/WIDGETS/text_widget.dart';

import '../../core/app_colors.dart';

class AlsoProductList extends StatelessWidget {
  const AlsoProductList({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productModel = Provider.of<ProductModel>(context);

    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          ProductDetailsScreen.routName,
          arguments: productModel.productID,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          height: 90,
          width: 260,
          child: Row(
            children: [
              /////////////// Image ///
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FancyShimmerImage(
                    imageUrl: productModel.productImage,
                  ),
                ),
              ),

              const SizedBox(
                width: 7,
              ),
              /////////////  product details
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        productModel.productTitle,
                        maxLines: 2,
                        style: GoogleFonts.akatab(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "AED ${productModel.productPrice}",
                      style: GoogleFonts.alatsi(
                          fontSize: 15, color: Colors.black87),
                    ),
                    SubtitleTextWidget(
                      label: "only ${productModel.productQty} left in stock",
                      fontSize: 10,
                      color: AppColors.goldenColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
