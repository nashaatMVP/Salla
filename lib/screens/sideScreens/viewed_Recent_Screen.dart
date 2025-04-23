import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/product_widget.dart';
import '../../providers/viewed_product_provider.dart';
import '../../shared/app/custom_empty_widget.dart';
import '../../shared/app/custom_text.dart';
import '../../shared/theme/app_colors.dart';

class ViewedRecentScreen extends StatelessWidget {
  const ViewedRecentScreen({super.key});
  static const routName = "/ViewedRecentScreen";
  final bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final viwedProductProvider = Provider.of<ViewedProductProvider>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;
    return viwedProductProvider.getViewedProductItems.isEmpty
        ? const Scaffold(
            body: EmptyBagWidget(
              isCart: true,
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
                  icon:  Icon(
                    Icons.cancel,
                    color: appColors.primaryColor
                    ,
                  )),
              centerTitle: true,
              title: TextWidgets.bodyText1("[ ${viwedProductProvider.getViewedProductItems.length} ] Items"),

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
