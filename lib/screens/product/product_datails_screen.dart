import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:salla/screens/cart/model/cart_model.dart';
import 'package:salla/screens/product/widgets/also_widget.dart';
import 'package:salla/screens/product/widgets/product_image.dart';
import 'package:salla/screens/product/widgets/rating_bar.dart';
import 'package:salla/shared/app/constants.dart';
import 'package:salla/shared/app/custom_button.dart';
import 'package:salla/shared/app/custom_container.dart';
import 'package:salla/shared/app/custom_divider.dart';
import 'package:salla/shared/app/photo_link.dart';
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

      if (oldPrice == null || newPrice == null || oldPrice <= 0 || newPrice >= oldPrice) {
        return "0%";
      }

      double discount = ((oldPrice - newPrice) / oldPrice) * 100;
      return "${discount.toStringAsFixed(0)}%";
    }
    Map<String, Future<Map<String, dynamic>>> userDetailsCache = {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight: 0,backgroundColor: Colors.white38),
      body: getCurrentProduct == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// image
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: ProductImage(path: getCurrentProduct.productImage)),
                  kGap10,
                  Container(
                    decoration: BoxDecoration(
                      color: appColors.secondaryColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          kGap20,
                          /// star
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 20,
                                color: Colors.yellow.shade800,
                              ),
                              kGap5,
                              TextWidgets.bodyText(
                                getCurrentProduct.productrating.toString(),
                                fontSize: 18,
                                color: appColors.primaryColor,
                              ),
                              const Spacer(),
                              CustomContainer(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            ],
                          ),
                          kGap10,
                          /// Details
                          SizedBox(
                            width: 270,
                            child: TextWidgets.subHeading(
                              getCurrentProduct.productTitle,
                              color: appColors.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                          kGap5,
                          TextWidgets.bodyText1(
                            "AED ${getCurrentProduct.productPrice}",
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: appColors.primaryColor,
                          ),
                          kGap5,
                          TextWidgets.subHeading(
                            "Stock: ${getCurrentProduct.productQty} in Stock",
                            fontSize: 14,
                            color: appColors.primaryColor,
                          ),
                          kGap30,
                          const CustomTitles(text: "Overview"),
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
                          kGap5,
                          getCurrentProduct.productrating == null ? const CustomTitles(text: "Reviews") : const SizedBox.shrink(),
                          kGap10,
                          CustomButton(
                            onPressed: () async {
                              cartProvider.isProdInCart(productId: productId)
                              ? await cartProvider.clearCartFromFirestore(context: context)
                              : cartProvider.addProductToCart(productId: productId);
                            },
                            text: cartProvider.isProdInCart(productId: productId) ? "Remove From Cart" : "Add To Cart",
                            textColor: appColors.secondaryColor,
                            backgroundColor: appColors.primaryColor,
                          ),
                          kGap30,
                          // FutureBuilder<List<RatingModelAdvanced>>(
                          //   future: ratingProvider.fetchproductreview(productId),
                          //   builder: (context, snapshot) {
                          //     // if (snapshot.connectionState == ConnectionState.waiting) {
                          //     //   return const CupertinoActivityIndicator();
                          //     // }
                          //     //
                          //     // if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          //     //   return const Text("No reviews available");
                          //     // }
                          //     final reviews = snapshot.data!;
                          //     return ListView.builder(
                          //       shrinkWrap: true,
                          //       padding: EdgeInsets.zero,
                          //       physics: const NeverScrollableScrollPhysics(),
                          //       itemCount: reviews.length,
                          //       itemBuilder: (ctx, index) {
                          //         final review = reviews[index];
                          //
                          //         // Cache user details to prevent multiple requests
                          //         userDetailsCache.putIfAbsent(
                          //             review.userId,
                          //                 () => ratingProvider
                          //                 .getUserDetails(review.userId));
                          //
                          //         return FutureBuilder<Map<String, dynamic>>(
                          //           future: userDetailsCache[review.userId],
                          //           builder: (context, userSnapshot) {
                          //             // if (userSnapshot.connectionState == ConnectionState.waiting) {
                          //             //   return const CircularProgressIndicator();
                          //             // }
                          //             //
                          //             // if (!userSnapshot.hasData || userSnapshot.data == null) {
                          //             //   return const Text("User data unavailable");
                          //             // }
                          //
                          //             final user = userSnapshot.data!;
                          //             return RatingBarCard(
                          //               image: user["userImage"] ??  PhotoLink.defaultImg,
                          //               titleReview: review.titlereview,
                          //               subTitleReview:review.review,
                          //               ratingNumber: "${double.tryParse(review.rating) ?? 0.0}",
                          //             );
                          //           },
                          //         );
                          //       },
                          //     );
                          //   },
                          // ),
                          kGap40,
                          const CustomTitles(text: "You may Also Like"),
                          kGap10,
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
                          kGap200,
                        ],
                      ),
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
