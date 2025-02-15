import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/screens/cart/provider/cart_provider.dart';
import 'package:smart_shop/providers/viewed_product_provider.dart';
import 'package:smart_shop/shared/constants.dart';
import 'package:smart_shop/shared/custom_container.dart';
import 'package:smart_shop/shared/heart_widget.dart';
import '../../models/product_model.dart';
import '../../shared/custom_text.dart';
import '../../shared/theme/app_colors.dart';
import '../../sideScreens/product_datails_screen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.offerBgColor,  this.isOffer = true});
  final Color offerBgColor;
  final bool isOffer;

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final viwedProductProvider = Provider.of<ViewedProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;

    return GestureDetector(
      onTap: () async {
        viwedProductProvider.addViewedProduct(
          productId: productModel.productID,
        );
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
              width: 170,
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
                              height: 70,
                              width: 70,
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextWidgets.bodyText1(
                             productModel.productTitle,
                             maxLines: 2,
                             color: appColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        kGap5,
                        RatingBarIndicator(
                          rating: productModel.productrating!.toDouble(),
                          itemBuilder: (context, index) => const Icon(Icons.star, color: CupertinoColors.activeGreen),
                          unratedColor: Colors.grey.shade400,
                          itemCount: 5,
                          itemSize: 13.0,
                          direction: Axis.horizontal,
                        ),
                        kGap5,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    TextWidgets.bodyText1("AED",color: appColors.primaryColor) ,
                                    kGap5,
                                    TextWidgets.bodyText1(productModel.productPrice,fontSize: 15,fontWeight: FontWeight.bold,color: appColors.primaryColor),
                                  ],
                                ),
                                kGap10,
                                TextWidgets.bodyText1(productModel.productOldPrice == null ? "" : productModel.productOldPrice.toString(),decoration: TextDecoration.lineThrough,color: CupertinoColors.activeGreen),
                              ],
                            ),
                          ],
                        ),
                        kGap15,
                        Row(
                          children: [
                              Icon(
                              Icons.shopping_bag_outlined,
                              size: 12,
                              color: appColors.primaryColor,
                            ),
                            kGap5,
                            TextWidgets.bodyText1(
                             "Only ${productModel.productQty} left In Stock",
                              fontSize: 10,
                              color: appColors.primaryColor,
                            ),
                          ],
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
            top: 3,
            left: 3,
            child: Visibility(
              visible: productModel.productOldPrice!.isNotEmpty,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: offerBgColor,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(8)),
                ),
                child:  TextWidgets.bodyText1(
                  "Offer %",
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          /// heart
          Positioned(
            top: 4,
            right: 5,
            child: CustomContainer(
              padding: const EdgeInsets.all(6),
              decoration:  const BoxDecoration(shape: BoxShape.rectangle, color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(8),
                ),
              ),
              child: HeartButton(
                productID: productModel.productID,
                size: 16,
                enabledColor: Colors.red,
              ),
            ),
          ),

          /// cart
          Positioned(
            top: 190,
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
              child: Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                padding: const EdgeInsets.all(5),
                child: Icon(
                  cartProvider.isProdInCart(productId: productModel.productID)
                      ? Icons.check
                      : Icons.add_shopping_cart,
                  size: 16,
                  color: Colors.black,
                ),
              ),
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
