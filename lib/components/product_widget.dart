import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:salla/shared/app/constants.dart';
import '../screens/cart/provider/cart_provider.dart';
import '../providers/products_provider.dart';
import '../providers/viewed_product_provider.dart';
import '../shared/app/custom_text.dart';
import '../shared/theme/app_colors.dart';
import '../screens/product/product_datails_screen.dart';
import '../shared/app/heart_widget.dart';

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
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: FancyShimmerImage(
                        imageUrl: getCurrentProduct.productImage,
                        width: 70,
                        height: 70,
                      ),
                    ),
                    kGap15,
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextWidgets.bodyText1(
                        getCurrentProduct.productTitle,
                        maxLines: 1,
                      ),
                    ),
                    kGap5,
                    SizedBox(
                      height: 23,
                      child: TextWidgets.bodyText1(
                        getCurrentProduct.productDescreption,
                        maxLines: 1,
                      ),
                    ),
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
                        Flexible(
                          child: HeartButton(
                            productID: getCurrentProduct.productID,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    kGap10,
                    Row(
                      children: [
                        Row(
                          children: [
                             TextWidgets.bodyText1(
                             "AED",
                              maxLines: 1,
                            ),
                            kGap5,
                            TextWidgets.bodyText1(
                                  "${getCurrentProduct.productPrice} ",
                              maxLines: 1,
                              fontSize: 15,
                            ),
                          ],
                        ),
                        kGap5,
                        Text(
                          getCurrentProduct.productOldPrice == null
                              ? ""
                              : getCurrentProduct.productOldPrice
                                  .toString(),
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    kGap10,
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
                    ),
                    kGap20,
                    TextWidgets.bodyText1(
                      "Only ${getCurrentProduct.productQty} In Stock",
                      fontSize: 13,
                    ),
                    kGap10,
                  ],
                ),
              ),
            ),
          );
  }
}
