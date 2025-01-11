import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/PROVIDERS/wishList_provider.dart';
import 'package:smart_shop/WIDGETS/empty_widget.dart';
import 'package:smart_shop/WIDGETS/text_widget.dart';

import '../core/app_colors.dart';
import '../widgets/itemWidgets/product_widget.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});
  static const routName = "/WishListScreen";
  final bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);
    return wishListProvider.getWishListItems.isEmpty
        ? const Scaffold(
            body: EmptyBagWidget(
              image: "IMG/bag/emptyCart.png",
              title: "Your WishList looks empty.",
              subTitle: "what are you waiting for !!",
              buttonTitle: "Shop Now",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              toolbarHeight: 40,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: AppColors.goldenColor,
                  )),
              centerTitle: true,
              title: AppNameTextWidget(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                text: "[ ${wishListProvider.getWishListItems.length} ] Items",
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      wishListProvider.clearLocalWishList();
                    },
                    child: const Text("Clear All")),
              ],
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: DynamicHeightGridView(
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    builder: (context, index) {
                      return ProductWidget(
                        productId: wishListProvider.getWishListItems.values
                            .toList()[index]
                            .producttID,
                      );
                    },
                    itemCount: wishListProvider.getWishListItems.length,
                  ),
                ),
              ],
            ),
          );
  }
}
