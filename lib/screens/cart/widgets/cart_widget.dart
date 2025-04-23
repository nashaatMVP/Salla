import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:salla/screens/cart/model/cart_model.dart';
import 'package:salla/screens/cart/widgets/qty_widget.dart';
import 'package:salla/shared/app/custom_container.dart';
import 'package:salla/shared/app/photo_link.dart';
import '../../../shared/app/constants.dart';
import '../../../providers/products_provider.dart';
import '../../../shared/app/custom_text.dart';
import '../../../shared/theme/app_colors.dart';

class CartWidget extends StatelessWidget {
   const CartWidget({super.key});


  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final cartModel = Provider.of<CartModel>(context);
    final productsProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productsProvider.findById(cartModel.producttID);
    String getOffer(String oldPriceStr, String newPriceStr) {
      double? oldPrice = double.tryParse(oldPriceStr);
      double? newPrice = double.tryParse(newPriceStr);

      if (oldPrice == null || newPrice == null || oldPrice <= 0 || newPrice >= oldPrice) {
        return "0%";
      }

      double discount = ((oldPrice - newPrice) / oldPrice) * 100;
      return "${discount.toStringAsFixed(0)}%";
    }


    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: CustomContainer(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: FancyShimmerImage(
                          imageUrl: getCurrentProduct.productImage,
                          height: 60,
                          width: 60,
                        ),
                      ),
                      kGap10,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .70,
                            child: TextWidgets.bodyText1(
                                getCurrentProduct.productTitle,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                maxLines: 2,
                                color: appColors.primaryColor,
                            ),
                          ),
                          kGap10,
                          /// prices
                          Row(
                            children: [
                              TextWidgets.subHeading(
                                  "AED",
                                  fontSize: 10,
                                  color: appColors.primaryColor,
                              ),
                              TextWidgets.bodyText1(
                                  " ${getCurrentProduct.productPrice}",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: appColors.primaryColor,
                              ),
                              kGap10,
                              Text("${getCurrentProduct.productOldPrice}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              kGap10,
                              TextWidgets.bodyText1(
                                "${getOffer("${getCurrentProduct.productOldPrice}", getCurrentProduct.productPrice)} OFF",
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: Colors.green.shade500,
                              ),
                            ],
                          ),
                          kGap20,
                          const QtyWidget(),
                          kGap20,
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
          );
  }
}


