import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:salla/screens/cart/provider/cart_provider.dart';
import 'package:salla/providers/viewed_product_provider.dart';
import 'package:salla/shared/app/custom_container.dart';
import 'package:salla/shared/app/heart_widget.dart';
import '../../../models/product_model.dart';
import '../../../shared/app/constants.dart';
import '../../../shared/app/custom_text.dart';
import '../../../shared/theme/app_colors.dart';
import '../../product/product_datails_screen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.offerBgColor,
    this.isOffer = true,
    this.categoryName,
    this.width = 200,
  });
  final bool isOffer;
  final Color offerBgColor;
  final String? categoryName;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final viewProducts = Provider.of<ViewedProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;
    String getOffer(String oldPriceStr, String newPriceStr) {
      double? oldPrice = double.tryParse(oldPriceStr);
      double? newPrice = double.tryParse(newPriceStr);
      if (oldPrice == null || newPrice == null || oldPrice <= 0 || newPrice >= oldPrice) {
        return "0%";
      }
      double discount = ((oldPrice - newPrice) / oldPrice) * 100;
      return "${discount.toStringAsFixed(0)}%";
    }


    return GestureDetector(
      onTap: () async {
        viewProducts.addViewedProduct(productId: productModel.productID);
        await Navigator.pushNamed(
          context,
          ProductDetailsScreen.routName,
          arguments: productModel.productID,
        );
      },

      child: Stack(
        children: [
          Card(
            elevation: 2,
            shadowColor: Colors.grey.shade900,
            color: appColors.secondaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  CustomContainer(
                    color: Colors.white,
                    width: double.infinity,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: FancyShimmerImage(
                                imageUrl: productModel.productImage,
                              ),
                            ),
                          ),
                        ),
                        kGap10,
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        kGap10,
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextWidgets.bodyText1(
                            productModel.productTitle,
                            maxLines: 1,
                            fontSize: 15,
                            fontWeight: FontWeight.w100,
                            color: appColors.primaryColor,
                          ),
                        ),
                        kGap10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    TextWidgets.bodyText1("AED",color: appColors.primaryColor) ,
                                    kGap5,
                                    TextWidgets.bodyText1(productModel.productPrice,fontSize: 17,fontWeight: FontWeight.bold,color: appColors.primaryColor),
                                  ],
                                ),
                                kGap10,
                                TextWidgets.bodyText1(productModel.productOldPrice == null ? "" : productModel.productOldPrice.toString(),decoration: TextDecoration.lineThrough,color: Colors.green.shade600,fontWeight: FontWeight.bold),
                              ],
                            ),
                          ],
                        ),
                        kGap10,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade400,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: TextWidgets.bodyText1(
                            "express",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        kGap10,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          /// offer
          if(isOffer)
          Positioned(
              top: 14,
              left: 8,
              child: Visibility(
                visible: productModel.productOldPrice!.isNotEmpty,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                  decoration: BoxDecoration(
                    color: offerBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:  TextWidgets.bodyText1(
                    "${getOffer("${productModel.productOldPrice}", productModel.productPrice)} Offer",
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          /// heart
          Positioned(
            top: 10,
            right: 5,
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.0,vertical: 4),
                child: HeartButton(
                  productID: productModel.productID,
                  size: 18,
                  enabledColor: Colors.red,
                ),
              ),
            ),
          ),
          /// cart
          Positioned(
            top: 97,
            right: 8,
            child: InkWell(
              onTap: () async {
                if (cartProvider.isProdInCart(
                    productId: productModel.productID)) {
                  return;
                }
                cartProvider.addProductToCart(
                    productId: productModel.productID);
                try {
                  await cartProvider.addToCartFirebase(
                    productId: productModel.productID,
                    qty: 1,
                    context: context,
                  );
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  print(e.toString());
                }
              },
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7.0,vertical: 4),
                  child: Icon(
                    cartProvider.isProdInCart(productId: productModel.productID)
                        ? Icons.check
                        : Icons.add_shopping_cart,
                    size: 19,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          /// rating
          Positioned(
            top: 110,
            left: 8,
            child: Visibility(
              visible: productModel.productOldPrice!.isNotEmpty,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20),
                ),
                child:  Row(
                  children: [
                    Icon(CupertinoIcons.star_fill,size: 12,color: Colors.yellow.shade700),
                    kGap5,
                    TextWidgets.bodyText1(
                      "${productModel.productrating}",
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );


  }
}
