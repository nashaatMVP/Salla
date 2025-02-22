import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import '../models/rating_model.dart';
import '../screens/cart/provider/cart_provider.dart';
import '../providers/products_provider.dart';
import '../providers/rating_provider.dart';
import '../shared/app/custom_text.dart';
import '../shared/theme/app_colors.dart';
import '../shared/app/heart_widget.dart';
import '../widgets/itemWidgets/also_widget.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    super.key,
  });
  static const routName = "/ProductDetailsScreen";

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final productsProvider = Provider.of<ProductProvider>(context);
    final ratingProvider = Provider.of<RatingProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    String? productId = ModalRoute.of(context)!.settings.arguments as String?;
    final getCurrentProduct = productsProvider.findById(productId!);
    Size size = MediaQuery.of(context).size;
    double calculateHeightForItem(RatingModelAdvanced review) {
      double userRowHeight = 60.0;
      double reviewTextHeight = 50.0;
      double padding = 20.0;
      double totalItemHeight = userRowHeight + reviewTextHeight + padding;
      return totalItemHeight;
    }

    return Scaffold(
      appBar: AppBar(
        title: TextWidgets.heading("Salla"),

      ),
      body: getCurrentProduct == null
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///////////////////////  Title & Category ////////////////////
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getCurrentProduct.productTitle,
                          style:
                              GoogleFonts.aldrich(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            color: appColors.primaryColor,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.category_outlined,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                getCurrentProduct.productcategory,
                                style: GoogleFonts.alata(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    /////////////////////  Image  /////////////////////////
                    Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: size.width * 0.6,
                            height: size.width * 0.6,
                            child: InteractiveViewer(
                              boundaryMargin: const EdgeInsets.all(10),
                              maxScale: 5.0,
                              minScale: 0.001,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: FancyShimmerImage(
                                  imageUrl: getCurrentProduct.productImage,
                                  height: size.height * 0.45,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                        ),

                        ////////////////////// Heart /////////////////////////////
                        Positioned(
                          top: 0,
                          right: 10,
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              child: HeartButton(
                                productID: getCurrentProduct.productID,
                                size: 20,
                                colorDisable: appColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        ////////////////////// Cart /////////////////////////////
                        Positioned(
                          top: 50,
                          right: 10,
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              child: InkWell(
                                  onTap: () async {
                                    if (cartProvider.isProdInCart(
                                        productId:
                                            getCurrentProduct.productID)) {
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
                                  child: Icon(
                                    cartProvider.isProdInCart(
                                            productId:
                                                getCurrentProduct.productID)
                                        ? Icons.check
                                        : Icons.add_shopping_cart,
                                    size: 20,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                        ),
                        ////////////////////// Share /////////////////////////////
                        Positioned(
                          top: 100,
                          right: 10,
                          child: InkWell(
                            onTap: () async {
                              await Share.share(
                                'https://www.amazon.ae/', //application Link
                                subject: 'SALLA',
                              );
                            },
                            child: Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child:  Icon(
                                  Icons.share,
                                  size: 20,
                                  color: appColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    ////////////////////// price and old price //////////////////
                    Row(
                      children: [
                        Text(
                          "${getCurrentProduct.productPrice} AED",
                          style: GoogleFonts.alatsi(fontSize: 17),
                        ),
                        const SizedBox(
                          width: 9,
                        ),
                        Text(
                          "${getCurrentProduct.productOldPrice}",
                          style: GoogleFonts.alatsi(
                              color: Colors.red.shade800,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    /////////////////////// Rating ///////////////////////////////
                    RatingBarIndicator(
                      rating: getCurrentProduct.productrating!.toDouble(),
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: appColors.primaryColor,
                      ),
                      unratedColor: Colors.grey.shade600,
                      itemCount: 5,
                      itemSize: 20.0,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    /////////////////////// only in Stock ///////////////////////
                    Row(
                      children: [
                        Icon(
                          Icons.shopping_bag,
                          size: 16,
                          color: appColors.primaryColor,
                        ),
                        Padding(
                          padding:  EdgeInsets.only(top: 5.0),
                          child :TextWidgets.bodyText1("  Only ${getCurrentProduct.productQty} in Stock",),


                        ),
                      ],
                    ),
                    /////////////////////// Descrption //////////////////////////
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        const CustomTitles(text: "Overview"),

                        SingleChildScrollView(
                          child: ReadMoreText(
                            getCurrentProduct.productDescreption,
                            trimLines: 3,
                            textAlign: TextAlign.justify,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: "  see more ",
                            trimExpandedText: "  see less ",
                            lessStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: appColors.primaryColor,),
                            moreStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: appColors.primaryColor),
                            style: GoogleFonts.abel(),
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),
                        //////////////////////////////////  Reviews  /////////////////////////////////////////
                        Visibility(
                          visible: getCurrentProduct.productrating != null,
                          child: const CustomTitles(text: "Reviews"),
                        ),

                        /////////////////////////////////   user rating  /////////////////////////////////////
                        // FutureBuilder<List<RatingModelAdvanced>>(
                        //   future: ratingProvider.fetchproductreview(productId),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.connectionState ==
                        //         ConnectionState.waiting) {
                        //       return const Center(
                        //         child: CircularProgressIndicator(),
                        //       );
                        //     } else if (snapshot.hasError) {
                        //       return SelectableText(
                        //         snapshot.error.toString(),
                        //       );
                        //     } else if (!snapshot.hasData ||
                        //         ratingProvider.getreviews.isEmpty) {}
                        //     double totalListViewHeight = 0.0;
                        //     if (snapshot.hasData) {
                        //       for (var review in snapshot.data!) {
                        //         totalListViewHeight +=
                        //             calculateHeightForItem(review);
                        //       }
                        //     }
                        //
                        //     return SizedBox(
                        //       height: totalListViewHeight,
                        //       child: ListView.separated(
                        //         physics: const BouncingScrollPhysics(),
                        //         itemCount: snapshot.data!.length,
                        //         itemBuilder: (ctx, index) {
                        //           final review = snapshot.data![index];
                        //           final userDetails = ratingProvider
                        //               .getUserDetails(review.userId);
                        //
                        //           return FutureBuilder(
                        //             future: userDetails,
                        //             builder: (BuildContext context,
                        //                 AsyncSnapshot userSnapshot) {
                        //               if (userSnapshot.connectionState ==
                        //                   ConnectionState.waiting) {
                        //                 return const CircularProgressIndicator();
                        //               } else if (userSnapshot.hasError) {
                        //                 return Text(
                        //                     'Error: ${userSnapshot.error}');
                        //               } else if (!userSnapshot.hasData) {
                        //                 return const SizedBox(); // Return an empty widget or handle as needed
                        //               }
                        //
                        //               final user = userSnapshot.data!;
                        //               return Padding(
                        //                 padding: const EdgeInsets.symmetric(
                        //                     horizontal: 2, vertical: 0),
                        //                 child: Column(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.start,
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   children: [
                        //                     Row(
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment
                        //                               .spaceBetween,
                        //                       children: [
                        //                         Row(
                        //                           children: [
                        //                             CircleAvatar(
                        //                               backgroundImage:
                        //                                   NetworkImage(
                        //                                 user["userImage"] ??
                        //                                     "https://pbs.twimg.com/media/FBBFtDvVcAQrSAG.png",
                        //                               ), // User image fetched based on userId
                        //                               radius: 20,
                        //                             ),
                        //                             const SizedBox(width: 10),
                        //                             Column(
                        //                               children: [
                        //                                 Text(
                        //                                   user["userName"]
                        //                                           .toString() ??
                        //                                       'user3223388222', // User name fetched based on userId
                        //                                   style:
                        //                                       const TextStyle(
                        //                                     fontWeight:
                        //                                         FontWeight.bold,
                        //                                   ),
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                           ],
                        //                         ),
                        //                         Row(
                        //                           children: [
                        //                             Text(
                        //                                 "${double.parse(review.rating)}" ??
                        //                                     "5.0"),
                        //                             const SizedBox(
                        //                               width: 10,
                        //                             ),
                        //                             Icon(
                        //                               Icons.star,
                        //                               color:
                        //                               appColors.primaryColor,
                        //                             ),
                        //                             const SizedBox(
                        //                               width: 10,
                        //                             ),
                        //                           ],
                        //                         ),
                        //                       ],
                        //                     ),
                        //                     const SizedBox(
                        //                       height: 4,
                        //                     ),
                        //                     Column(
                        //                       crossAxisAlignment:
                        //                           CrossAxisAlignment.start,
                        //                       children: [
                        //                         ///////////////////// Title Review /////////////////////////
                        //                         TextWidgets.bodyText1(review.titlereview
                        //                             .toString() ??
                        //                             "Awsome"),
                        //
                        //                         const SizedBox(
                        //                           height: 3,
                        //                         ),
                        //                         ///////////////////// review /////////////////////////
                        //                         Text(
                        //                           review.review.toString(),
                        //                           style: GoogleFonts.akatab(),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ],
                        //                 ),
                        //               );
                        //             },
                        //           );
                        //         },
                        //         separatorBuilder:
                        //             (BuildContext context, int index) {
                        //           return Divider(
                        //             thickness: 1,
                        //             color: appColors.primaryColor,
                        //           );
                        //         },
                        //       ),
                        //     );
                        //   },
                        // ),

                        ///////////////////////////// you may also like //////////////////////////////////
                        const CustomTitles(text: "You may Also Like"),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: productsProvider
                                          .findByCategory(
                                              categoryName: getCurrentProduct
                                                  .productcategory)
                                          .length <
                                      10
                                  ? productsProvider
                                      .findByCategory(
                                          categoryName:
                                              getCurrentProduct.productcategory)
                                      .length
                                  : 10,
                              itemBuilder: (context, index) {
                                return ChangeNotifierProvider.value(
                                    value: productsProvider.findByCategory(
                                        categoryName: getCurrentProduct
                                            .productcategory)[index],
                                    child: const AlsoProductList());
                              }),
                        ),

                        SizedBox(
                          height: size.height * 0.1,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CustomTitles extends StatelessWidget {
  const CustomTitles({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          bottom: 15,
        ),
        child: Text(
          text,
          style: GoogleFonts.alata(
            fontSize: 17,
            color: Colors.blue.shade800,
            fontWeight: FontWeight.normal,
          ),
        ));
  }
}
