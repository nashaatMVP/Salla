import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:smart_shop/screens/product/widgets/product_image.dart';
import 'package:smart_shop/screens/product/widgets/rating_bar.dart';
import 'package:smart_shop/shared/app/constants.dart';
import 'package:smart_shop/shared/app/custom_container.dart';
import 'package:smart_shop/shared/app/photo_link.dart';
import '../../models/rating_model.dart';
import '../cart/provider/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/rating_provider.dart';
import '../../shared/app/custom_text.dart';
import '../../shared/theme/app_colors.dart';

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
    double calculateHeightForItem(RatingModelAdvanced review) {
      double userRowHeight = 10.0;
      double reviewTextHeight = 50.0;
      double padding = 1.0;
      double totalItemHeight = userRowHeight + reviewTextHeight + padding;
      return totalItemHeight;
    }
    String getOffer(String oldPriceStr, String newPriceStr) {
      double? oldPrice = double.tryParse(oldPriceStr);
      double? newPrice = double.tryParse(newPriceStr);

      if (oldPrice == null ||
          newPrice == null ||
          oldPrice <= 0 ||
          newPrice >= oldPrice) {
        return "0%";
      }

      double discount = ((oldPrice - newPrice) / oldPrice) * 100;
      return "${discount.toStringAsFixed(0)}%";
    }

    Map<String, Future<Map<String, dynamic>>> userDetailsCache = {};

    return Scaffold(
      body: getCurrentProduct == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// image
                  ProductImage(path: getCurrentProduct.productImage),
                  kGap20,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        kGap15,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 270,
                              child: TextWidgets.subHeading(
                                getCurrentProduct.productTitle,
                                color: appColors.primaryColor,
                                fontSize: 14,
                              ),
                            ),
                            TextWidgets.bodyText1(
                              " ${getCurrentProduct.productPrice} AED",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: appColors.primaryColor,
                            ),
                          ],
                        ),
                        kGap30,
                        CustomContainer(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          borderRadius: BorderRadius.circular(17),
                          color: appColors.primaryColor,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.category_outlined,
                                size: 12,
                                color: appColors.secondaryColor,
                              ),
                              kGap5,
                              TextWidgets.bodyText(
                                getCurrentProduct.productcategory,
                                fontSize: 10,
                                color: appColors.secondaryColor,
                              ),
                            ],
                          ),
                        ),
                        kGap10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidgets.subHeading(
                                "${getCurrentProduct.productQty} in Stock",
                                fontSize: 14,
                                color: CupertinoColors.destructiveRed,
                            ),
                          ],
                        ),
                        kGap20,
                        const CustomTitles(text: "Overview"),
                        kGap5,
                        SingleChildScrollView(
                          child: ReadMoreText(
                            getCurrentProduct.productDescreption,
                            trimLines: 3,
                            trimMode: TrimMode.Line,
                            textAlign: TextAlign.justify,
                            trimExpandedText: "   less ",
                            trimCollapsedText: "   more ",
                            lessStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: blueColor,
                            ),
                            moreStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: blueColor,
                            ),
                            style: TextStyle(
                                fontFamily: 'IBM Plex Sans',
                                fontSize: 12,
                                height: 1.8,
                                color: appColors.primaryColor),
                          ),
                        ),
                        kGap10,
                        getCurrentProduct.productrating == null ? const CustomTitles(text: "Reviews") : const SizedBox.shrink(),
                        kGap5,
                        kGap20,
                        // const CustomTitles(text: "You may Also Like"),
                        // SizedBox(
                        //   height: 100,
                        //   child: ListView.builder(
                        //       physics: const BouncingScrollPhysics(),
                        //       scrollDirection: Axis.horizontal,
                        //       itemCount: productsProvider
                        //           .findByCategory(
                        //           categoryName: getCurrentProduct
                        //               .productcategory)
                        //           .length <
                        //           10
                        //           ? productsProvider
                        //           .findByCategory(
                        //           categoryName:
                        //           getCurrentProduct.productcategory)
                        //           .length
                        //           : 10,
                        //       itemBuilder: (context, index) {
                        //         return ChangeNotifierProvider.value(
                        //             value: productsProvider.findByCategory(
                        //                 categoryName: getCurrentProduct
                        //                     .productcategory)[index],
                        //             child: const AlsoProductList());
                        //       }),
                        // ),

                        // FutureBuilder<List<RatingModelAdvanced>>(
                        //   future: ratingProvider.fetchproductreview(productId),
                        //   builder: (context, snapshot) {
                        //     double totalListViewHeight = 0.0;
                        //     if (snapshot.connectionState == ConnectionState.waiting) {
                        //       return const CupertinoActivityIndicator();
                        //     }
                        //     else if (snapshot.hasData) {
                        //       for (var review in snapshot.data!) {
                        //         totalListViewHeight += calculateHeightForItem(review);
                        //       }
                        //     }
                        //     return SizedBox(
                        //       height: totalListViewHeight,
                        //       child: ListView.separated(
                        //         physics: const NeverScrollableScrollPhysics(),
                        //         itemCount: snapshot.data!.length,
                        //         separatorBuilder: (BuildContext context, int index) => const SizedBox.shrink(),
                        //         itemBuilder: (ctx, index) {
                        //           final review = snapshot.data![index];
                        //           final userDetails = ratingProvider.getUserDetails(review.userId);
                        //           return FutureBuilder(
                        //             future: userDetails,
                        //             builder: (BuildContext context, AsyncSnapshot userSnapshot) {
                        //               final user = userSnapshot.data;
                        //               return RatingBarCard(
                        //                 image: user["userImage"] ?? PhotoLink.defaultImg,
                        //                 titleReview: review.titlereview.toString(),
                        //                 subTitleReview: review.review.toString(),
                        //                 ratingNumber: "${double.parse(review.rating)}",
                        //               );
                        //             },
                        //           );
                        //         },
                        //       ),
                        //     );
                        //
                        //
                        //   },
                        // ),

                        FutureBuilder<List<RatingModelAdvanced>>(
                          future: ratingProvider.fetchproductreview(productId),
                          builder: (context, snapshot) {
                            // if (snapshot.connectionState == ConnectionState.waiting) {
                            //   return const CupertinoActivityIndicator();
                            // }
                            //
                            // if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            //   return const Text("No reviews available");
                            // }

                            final reviews = snapshot.data!;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: reviews.length,
                              itemBuilder: (ctx, index) {
                                final review = reviews[index];

                                // Cache user details to prevent multiple requests
                                userDetailsCache.putIfAbsent(
                                    review.userId,
                                    () => ratingProvider
                                        .getUserDetails(review.userId));

                                return FutureBuilder<Map<String, dynamic>>(
                                  future: userDetailsCache[review.userId],
                                  builder: (context, userSnapshot) {
                                    // if (userSnapshot.connectionState == ConnectionState.waiting) {
                                    //   return const CircularProgressIndicator();
                                    // }
                                    //
                                    // if (!userSnapshot.hasData || userSnapshot.data == null) {
                                    //   return const Text("User data unavailable");
                                    // }

                                    final user = userSnapshot.data!;

                                    return RatingBarCard(
                                      image: user["userImage"] ??
                                          PhotoLink.defaultImg,
                                      titleReview:
                                          review.titlereview ?? "No Title",
                                      subTitleReview:
                                          review.review ?? "No Review",
                                      ratingNumber:
                                          "${double.tryParse(review.rating) ?? 0.0}",
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),

                        kGap30,
                      ],
                    ),
                  ),
                ],
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
    return TextWidgets.heading(
      text,
      fontSize: 17,
      color: Colors.blue.shade800,
      fontWeight: FontWeight.bold,
    );
  }
}
