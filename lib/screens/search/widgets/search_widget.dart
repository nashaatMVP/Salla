import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/shared/app/constants.dart';
import 'package:smart_shop/shared/app/custom_text.dart';
import '../../../providers/products_provider.dart';
import '../../../providers/viewed_product_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../product/product_datails_screen.dart';

class SearchWidget extends StatefulWidget {
  final String productId;

  const SearchWidget({
    super.key,
    required this.productId,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productsProvider.findById(widget.productId);
    final viwedProductProvider = Provider.of<ViewedProductProvider>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;


    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : GestureDetector(
          onTap: () async {
            viwedProductProvider.addViewedProduct(
              productId: getCurrentProduct.productID,
            );
            await Navigator.pushNamed(
              context,
              ProductDetailsScreen.routName,
              arguments: getCurrentProduct.productID,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgets.bodyText1(getCurrentProduct.productcategory,color: appColors.primaryColor,fontWeight: FontWeight.w700),
                kGap10,
                TextWidgets.bodyText(
                  getCurrentProduct.productTitle.split(' ').take(4).join('  '),
                  color: appColors.primaryColor,
                  fontWeight: FontWeight.w400,
                  maxLines: 1,
                ),
                const Spacer(),
                const Icon(CupertinoIcons.arrow_turn_right_up,color: CupertinoColors.systemGrey),
              ],
            ),
          ),
        );
  }
}
