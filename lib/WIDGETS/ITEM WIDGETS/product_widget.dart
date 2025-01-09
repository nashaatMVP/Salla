import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/CONSTANTS/app_colors.dart';
import 'package:smart_shop/PROVIDERS/cart_provider.dart';
import 'package:smart_shop/PROVIDERS/products_provider.dart';
import 'package:smart_shop/PROVIDERS/viewed_product_provider.dart';
import 'package:smart_shop/WIDGETS/heart_widget.dart';
import 'package:smart_shop/WIDGETS/text_widget.dart';

import '../../SIDE SCREENS/product_datails_screen.dart';

class ProductWidget extends StatefulWidget {
  final String productId;

  const ProductWidget({
    super.key,
    required this.productId,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final getCurrentProduct = productsProvider.findById(widget.productId);
    final viwedProductProvider = Provider.of<ViewedProductProvider>(context);
    Size size = MediaQuery.of(context).size;

    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : GestureDetector(
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
            child: Container(
              width: 165,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),

              ///////////////////////////////////////  IMAGE  //////////////////////////////////////////////////
              child: Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: FancyShimmerImage(
                            imageUrl: getCurrentProduct.productImage,
                          ),
                        ),
                      ),

                      /////////////////////////////  TITLE AND DEScription  //////////////////////////////////////////////////

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SubtitleTextWidget(
                              label: getCurrentProduct.productTitle,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.black,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          SizedBox(
                            height: 23,
                            child: TitlesTextWidget(
                              label: getCurrentProduct.productDescreption,
                              maxLines: 2,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      /////////////////////////////////RATING///////////////////////////////////////////////////

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingBarIndicator(
                            rating: getCurrentProduct.productrating!.toDouble(),
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.green,
                            ),
                            unratedColor: Colors.black,
                            itemCount: 5,
                            itemSize: 18.0,
                            direction: Axis.horizontal,
                          ),

                          //////////////////////////////////////////////Heart Button/////////////////////////////////
                          Flexible(
                            child: HeartButton(
                              productID: getCurrentProduct.productID,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),

                      //////////////////////////////PRICE AND CART//////////////////////////////////////////////
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    const TitlesTextWidget(
                                      label: "AED",
                                      maxLines: 1,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TitlesTextWidget(
                                      label:
                                          "${getCurrentProduct.productPrice} ",
                                      maxLines: 1,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                /////////////impelment//////////////////////
                                Text(
                                  getCurrentProduct.productOldPrice == null
                                      ? ""
                                      : getCurrentProduct.productOldPrice
                                          .toString(),
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 10,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                            //////////////////////////////////      CART      ////////////////////////////////////////////////////

                            InkWell(
                              child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: Icon(
                                    cartProvider.isProdInCart(
                                            productId:
                                                getCurrentProduct.productID)
                                        ? Icons.check
                                        : Icons.add_shopping_cart,
                                    color: Colors.black,
                                  )),
                              onTap: () async {
                                if (cartProvider.isProdInCart(
                                    productId: getCurrentProduct.productID)) {
                                  return;
                                }
                                cartProvider.addProductToCart(
                                    productId: getCurrentProduct.productID);
                                try {
                                  await cartProvider.addToCartFirebase(
                                    productId: getCurrentProduct.productID,
                                    qty: 1,
                                    context: context,
                                  );
                                } catch (e) {
                                  // ignore: use_build_context_synchronously
                                  print(e.toString());
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      /////////////////////////////////////////////       Only on Stock       //////////////////////////////////////////////////
                      TitlesTextWidget(
                        label: "Only ${getCurrentProduct.productQty} In Stock",
                        fontSize: 12,
                        color: AppColors.goldenColor,
                      ),

                      ///////////////////////////////////////////                             //////////////////////////////////////////////////
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
