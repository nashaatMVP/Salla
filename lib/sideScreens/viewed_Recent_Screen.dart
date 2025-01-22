import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/PROVIDERS/viewed_product_provider.dart';
import 'package:smart_shop/WIDGETS/empty_widget.dart';

import '../core/app_colors.dart';
import '../core/text_widget.dart';
import '../widgets/itemWidgets/product_widget.dart';

class ViewedRecentScreen extends StatelessWidget {
  const ViewedRecentScreen({super.key});
  static const routName = "/ViewedRecentScreen";
  final bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final viwedProductProvider = Provider.of<ViewedProductProvider>(context);
    return viwedProductProvider.getViewedProductItems.isEmpty
        ? const Scaffold(
            body: EmptyBagWidget(
              image: "assets/bag/emptyCart.png",
              title: "No viewed products",
              subTitle: "what are you waiting for ? browse some products",
              buttonTitle: "View Products",
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
                text:
                    "[ ${viwedProductProvider.getViewedProductItems.length} ] Items",
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      viwedProductProvider.clearLocalViewedProduct();
                    },
                    child: const Text("Clear All")),
              ],
            ),
            body: DynamicHeightGridView(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              builder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ProductWidget(
                    productId: viwedProductProvider.getViewedProductItems.values
                        .toList()[index]
                        .producttID,
                  ),
                );
              },
              itemCount: viwedProductProvider.getViewedProductItems.length,
            ),
          );
  }
}
