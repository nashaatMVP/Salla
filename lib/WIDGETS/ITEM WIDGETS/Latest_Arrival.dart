import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/CONSTANTS/app_colors.dart';
import 'package:smart_shop/MODELS/product_model.dart';
import 'package:smart_shop/PROVIDERS/cart_provider.dart';
import 'package:smart_shop/PROVIDERS/viewed_product_provider.dart';
import 'package:smart_shop/SIDE%20SCREENS/product_datails_screen.dart';
import 'package:smart_shop/WIDGETS/heart_widget.dart';
import 'package:smart_shop/WIDGETS/text_widget.dart';

class LatestArrivalProductWidget extends StatelessWidget {
  const LatestArrivalProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productModel = Provider.of<ProductModel>(context);
    final viwedProductProvider = Provider.of<ViewedProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
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
          Container(
            width: 170,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade100,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),

            ///////////////////////////////////////  IMAGE  //////////////////////////////////////////////////
            child: Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: size.width * .3,
                              width: size.width * .3,
                              child: FancyShimmerImage(
                                imageUrl: productModel.productImage,
                              ),
                            ),
                          ),
                        ),

                        /////////////////////////////////////////////////////////////////////
                      ],
                    ),

                    /////////////////////////////  TITLE & DEScription  //////////////////////////////////////
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TitlesTextWidget(
                            label: productModel.productTitle,
                            maxLines: 2,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    /////////////////////////////////  RATING  ///////////////////////////////////////

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingBarIndicator(
                          rating: productModel.productrating!.toDouble(),
                          itemBuilder: (context, index) =>
                              const Icon(Icons.star, color: Color(0xffCBB26A)),
                          unratedColor: Colors.grey.shade400,
                          itemCount: 5,
                          itemSize: 18.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),

                    ////////////////////////////// PRICE AND CART //////////////////////////////////////
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "AED",
                                    style: GoogleFonts.alatsi(
                                        fontSize: 13, color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    productModel.productPrice,
                                    style: GoogleFonts.alatsi(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              /////////////////////////////////   Old Price    ////////////////////////////
                              Text(
                                productModel.productOldPrice == null
                                    ? ""
                                    : productModel.productOldPrice.toString(),
                                style: GoogleFonts.alatsi(
                                  color: const Color.fromARGB(255, 187, 60, 60),
                                  fontSize: 13,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    /////////////////////////////////////////////       Only on Stock       //////////////////////////////////////////////////
                    Row(
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColors.goldenColor,
                          size: 12,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: TitlesTextWidget(
                            label:
                                "Only ${productModel.productQty} left In Stock",
                            fontSize: 11,
                            color: AppColors.goldenColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    ///////////////////////////////////////////                             //////////////////////////////////////////////////
                  ],
                ),
              ],
            ),
          ),

          ///////////////////////////////////////////  Offer //////////////////////////////////////
          Positioned(
            top: 2,
            left: 2,
            child: Visibility(
              visible: productModel.productOldPrice!.isNotEmpty,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade400,
                  borderRadius: const BorderRadius.only(
                      // bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      // topRight: Radius.circular(15),
                      topLeft: Radius.circular(8)),
                ),
                child: const TitlesTextWidget(
                  label: "Special Offer",
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          //////////////////////////// heart
          Positioned(
            top: 5,
            right: 8,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: HeartButton(
                  productID: productModel.productID,
                  size: 20,
                  enabledColor: AppColors.goldenColor,
                ),
              ),
            ),
          ),

          ///////////////////////////////// Cart
          Positioned(
            top: 110,
            right: 8,
            child: InkWell(
              child: SizedBox(
                  // width: 25,
                  // height: 25,
                  child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    cartProvider.isProdInCart(productId: productModel.productID)
                        ? Icons.check
                        : Icons.add_shopping_cart,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              )),
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
            ),
          ),
        ],
      ),
    );
  }
}
