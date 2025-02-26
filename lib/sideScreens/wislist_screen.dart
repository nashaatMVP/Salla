import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishList_provider.dart';
import '../shared/app/custom_text.dart';
import '../shared/theme/app_colors.dart';
import '../shared/app/custom_empty_widget.dart';
import '../widgets/itemWidgets/product_widget.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});
  static const routName = "/WishListScreen";
  final bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;
    return wishListProvider.getWishListItems.isEmpty
        ? const Scaffold(
            body: EmptyBagWidget(
              isCart: true,
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
                  icon:  Icon(
                    Icons.cancel,
                    color: appColors.primaryColor
                    ,
                  )),
              centerTitle: true,
              title: TextWidgets.bodyText1("[ ${wishListProvider.getWishListItems.length} ] Items"),

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
