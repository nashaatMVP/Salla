import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../shared/custom_text.dart';
import '../shared/theme/app_colors.dart';
import '../sideScreens/select_address_screen.dart';

class CartBottomSheetWidget extends StatelessWidget {
  const CartBottomSheetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    final productsProvider = Provider.of<ProductProvider>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Container(
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Theme.of(context).scaffoldBackgroundColor,
        border:  BorderDirectional(
          top: BorderSide(color: appColors.primaryColor, width: 2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 6,
                  ),
                  TextWidgets.bodyText1(
                        "Total: [ ${cartProvider.getCartItems.length} ] Products  [ ${cartProvider.getQty()} ] Items",
                    fontSize: 14,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidgets.bodyText1(
                        "SubTotal: ${cartProvider.getTotal(productProvider: productsProvider).toStringAsFixed(2)} AED",

                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.primaryColor
                ,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectAddressScreen(),
                    ));

                // await function();
              },
              child:TextWidgets.bodyText1("CheckOut"),
            ),
          ],
        ),
      ),
    );
  }
}
