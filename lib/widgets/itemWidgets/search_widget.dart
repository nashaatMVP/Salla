import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/PROVIDERS/products_provider.dart';
import 'package:smart_shop/PROVIDERS/viewed_product_provider.dart';

import '../../sideScreens/product_datails_screen.dart';

class SearchWidget extends StatefulWidget {
  final String productId;

  const SearchWidget({
    super.key,
    required this.productId,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductProvider>(context);

    final getCurrentProduct = productsProvider.findById(widget.productId);
    final viwedProductProvider = Provider.of<ViewedProductProvider>(context);

    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : Column(
            children: [
              GestureDetector(
                onTap: () async {
                  viwedProductProvider.addViewedProduct(
                    productId: getCurrentProduct.productID,
                  );
                  await Navigator.pushNamed(
                    context,
                    ProductDetailsScreen.routName,
                    arguments: getCurrentProduct.productID,
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //////////////////IMAGE\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: FancyShimmerImage(
                        imageUrl: getCurrentProduct.productImage,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    //////////////////////PRODUCT TITLE\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getCurrentProduct.productTitle,
                            maxLines: 2,
                            style: GoogleFonts.akatab(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ///////////////////////////PRICE////////////////////////////////////
                          Row(
                            children: [
                              Text(
                                "${getCurrentProduct.productPrice} AED",
                                style: GoogleFonts.alatsi(fontSize: 15),
                              ),
                              const SizedBox(
                                width: 9,
                              ),
                              Text(
                                "${getCurrentProduct.productOldPrice}",
                                style: GoogleFonts.alatsi(
                                  fontSize: 15,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /////////////////// End Of Big Column \\\\\\\\\\\\\\\\\\
                  ],
                ),
              ),
            ],
          );
  }
}
