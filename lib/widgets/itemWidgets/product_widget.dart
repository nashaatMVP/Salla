import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../screens/cart/provider/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/viewed_product_provider.dart';
import '../../shared/custom_text.dart';
import '../../shared/theme/app_colors.dart';
import '../../sideScreens/product_datails_screen.dart';
import '../../shared/heart_widget.dart';

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
    final appColors = Theme.of(context).extension<AppColors>()!;
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
                            child: TextWidgets.bodyText1(
                              getCurrentProduct.productTitle,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          SizedBox(
                            height: 23,
                            child: TextWidgets.bodyText1(
                  getCurrentProduct.productDescreption,
                              maxLines: 2,
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
                                     TextWidgets.bodyText1(
                             "AED",
                                      maxLines: 1,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TextWidgets.bodyText1(
                                          "${getCurrentProduct.productPrice} ",
                                      maxLines: 1,
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
                      TextWidgets.bodyText1(
                  "Only ${getCurrentProduct.productQty} In Stock",
                        fontSize: 12,
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
