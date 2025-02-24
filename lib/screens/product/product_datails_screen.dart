import 'dart:ui';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_shop/screens/product/widgets/product_image.dart';
import 'package:smart_shop/screens/product/widgets/rating_bar.dart';
import 'package:smart_shop/shared/app/constants.dart';
import 'package:smart_shop/shared/app/custom_appbar.dart';
import 'package:smart_shop/shared/app/custom_container.dart';
import 'package:smart_shop/shared/app/photo_link.dart';
import '../../models/product_model.dart';
import '../../models/rating_model.dart';
import '../cart/provider/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/rating_provider.dart';
import '../../shared/app/custom_text.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/app/heart_widget.dart';
import '../cart/widgets/qty_widget.dart';
import 'widgets/also_widget.dart';

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
      double userRowHeight = 69.0;
      double reviewTextHeight = 50.0;
      double padding = 20.0;
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
                        padding: const EdgeInsets.symmetric( horizontal: 10, vertical: 5),
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

                          TextWidgets.subHeading("${getCurrentProduct.productQty} in Stock",fontSize: 14, color: appColors.primaryColor),
                        ],
                      ),
                      kGap20,
                      const CustomTitles(text: "Overview"),
                      kGap5,
                      SingleChildScrollView(
                        child: ReadMoreText(
                          getCurrentProduct.productDescreption,
                          trimLines: 3,
                          textAlign: TextAlign.justify,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: "   more ",
                          trimExpandedText: "   less ",
                          lessStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                          moreStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                          style: TextStyle(fontFamily: 'IBM Plex Sans',fontSize: 12,height: 1.8,color: appColors.primaryColor),
                        ),
                      ),
                      kGap10,
                      getCurrentProduct.productrating == null ? const CustomTitles(text: "Reviews") : const SizedBox.shrink(),
                      kGap5,
                      FutureBuilder<List<RatingModelAdvanced>>(
                        future: ratingProvider.fetchproductreview(productId),
                        builder: (context, snapshot) {
                          double totalListViewHeight = 0.0;
                          if (snapshot.hasData) {
                            for (var review in snapshot.data!) {
                              totalListViewHeight += calculateHeightForItem(review);
                            }
                          }

                          return SizedBox(
                            height: totalListViewHeight,
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              separatorBuilder: (BuildContext context, int index) => const SizedBox.shrink(),
                              itemBuilder: (ctx, index) {
                                final review = snapshot.data![index];
                                final userDetails = ratingProvider.getUserDetails(review.userId);
                                return FutureBuilder(
                                  future: userDetails,
                                  builder: (BuildContext context, AsyncSnapshot userSnapshot) {
                                    final user = userSnapshot.data;
                                    return RatingBarCard(
                                        image: user["userImage"] ?? PhotoLink.defaultImg,
                                        titleReview: review.titlereview.toString(),
                                        subTitleReview: review.review.toString(),
                                        ratingNumber: "${double.parse(review.rating)}",
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const CustomTitles(text: "You may Also Like"),
                      kGap20,
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
