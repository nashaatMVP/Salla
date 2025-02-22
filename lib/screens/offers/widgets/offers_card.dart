import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/screens/cart/provider/cart_provider.dart';
import 'package:smart_shop/providers/viewed_product_provider.dart';
import 'package:smart_shop/shared/app/custom_button.dart';
import 'package:smart_shop/shared/app/custom_container.dart';
import 'package:smart_shop/shared/app/heart_widget.dart';
import '../../../models/product_model.dart';
import '../../../shared/app/constants.dart';
import '../../../shared/app/custom_text.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../sideScreens/product_datails_screen.dart';


class OffersCard extends StatelessWidget {
  const OffersCard({super.key, required this.offerBgColor, required this.isOffer});
  final Color offerBgColor;
  final bool isOffer;

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final viwedProductProvider = Provider.of<ViewedProductProvider>(context);
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

    if(productModel.productOldPrice != ""){
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
                    CustomContainer(
                      width: double.infinity,
                      color: appColors.primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: CustomButton(
                        text: "Buy Now",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        arrow: true,
                        arrowColor: appColors.secondaryColor,
                        backgroundColor: appColors.primaryColor,
                        textColor: appColors.secondaryColor,
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
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
