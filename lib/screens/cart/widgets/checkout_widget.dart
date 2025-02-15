import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/shared/constants.dart';
import 'package:smart_shop/shared/custom_container.dart';
import '../provider/cart_provider.dart';
import '../../../providers/products_provider.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../sideScreens/select_address_screen.dart';

class CartBottomSheetWidget extends StatelessWidget {
  const CartBottomSheetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productsProvider = Provider.of<ProductProvider>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;
    return BottomSheet(
        elevation: 10,
        backgroundColor: appColors.secondaryColor,
        onClosing: () {},
        builder: (e) =>  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
          child: CustomContainer(
            color: blueColor,
            height: 55,
            radius: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidgets.bodyText1("${cartProvider.getQty()} items",fontSize: 12,color: whiteColor),
                      TextWidgets.bodyText1("AED ${cartProvider.getTotal(productProvider: productsProvider).toStringAsFixed(2)}",fontSize: 15,fontWeight: FontWeight.bold,color: whiteColor),
                    ],
                  ),
                  TextWidgets.subHeading("CHECKOUT",color: whiteColor),
                  kGap5,
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectAddressScreen(),
                          ));
                    },
                    child: const CustomContainer(
                      child: Icon(CupertinoIcons.arrow_right_square_fill , color: Colors.white,size: 30),
                    ),
                  ),

                  // Flexible(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const SizedBox(
                  //         height: 6,
                  //       ),
                  //       TextWidgets.bodyText1(
                  //             "Total: [ ${cartProvider.getCartItems.length} ] Products  [ ${cartProvider.getQty()} ] Items",
                  //         fontSize: 14,
                  //       ),
                  //       const SizedBox(
                  //         height: 10,
                  //       ),
                  //       TextWidgets.bodyText1(
                  //             "SubTotal: ${cartProvider.getTotal(productProvider: productsProvider).toStringAsFixed(2)} AED",
                  //
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
