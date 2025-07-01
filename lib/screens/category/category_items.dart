import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salla/shared/app/custom_appbar.dart';
import '../../providers/products_provider.dart';
import '../../shared/app/constants.dart';
import '../../shared/app/custom_container.dart';
import '../../shared/app/custom_text.dart';
import '../../shared/theme/app_colors.dart';

class CategoryItems extends StatelessWidget {
  static const routName = "/categoryItems";

  const CategoryItems({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ModalRoute.of(context)!.settings.arguments as String;
    final productsProvider = Provider.of<ProductProvider>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;


    // Filter products by category name
    final filteredProducts = productsProvider.products
        .where((product) => product.productcategory == selectedCategory)
        .toList();

    return Scaffold(
      appBar: CustomAppBar(onDelete: () {}, text: selectedCategory),
      body: filteredProducts.isEmpty
          ? const Center(child: CustomText(text: "Not Products Now !",color: Colors.black))
          : GridView.builder(
          padding: const EdgeInsets.only(top: 10),
          itemCount: filteredProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return Card(
              elevation: 1,
              shadowColor: Colors.grey.shade900,
              color: appColors.secondaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SizedBox(
                width: 155,
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
                                height: 100,
                                width: 100,
                                child: FancyShimmerImage(
                                  imageUrl: product.productImage,
                                ),
                              ),
                            ),
                          ),
                          kGap10,
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          kGap10,
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextWidgets.bodyText1(
                              product.productTitle,
                              maxLines: 2,
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                              color: appColors.primaryColor,
                            ),
                          ),
                          kGap10,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      TextWidgets.bodyText1("AED",color: appColors.primaryColor) ,
                                      kGap5,
                                      TextWidgets.bodyText1(product.productPrice,fontSize: 17,fontWeight: FontWeight.bold,color: appColors.primaryColor),
                                    ],
                                  ),
                                  kGap10,
                                  TextWidgets.bodyText1(product.productOldPrice == null ? "" : product.productOldPrice.toString(),decoration: TextDecoration.lineThrough,color: Colors.green.shade600,fontWeight: FontWeight.bold),
                                ],
                              ),
                            ],
                          ),
                          kGap10,
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade400,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: TextWidgets.bodyText1(
                              "express",
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          kGap10,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
      ), 
    );
  }
}
