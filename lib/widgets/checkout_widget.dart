import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/PROVIDERS/cart_provider.dart';
import '../PROVIDERS/products_provider.dart';
import '../core/app_colors.dart';
import '../core/text_widget.dart';
import '../sideScreens/select_address_screen.dart';

class CartBottomSheetWidget extends StatelessWidget {
  const CartBottomSheetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productsProvider = Provider.of<ProductProvider>(context);

    return Container(
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const BorderDirectional(
          top: BorderSide(color: AppColors.goldenColor, width: 2),
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
                  TitlesTextWidget(
                    label:
                        "Total: [ ${cartProvider.getCartItems.length} ] Products  [ ${cartProvider.getQty()} ] Items",
                    fontSize: 14,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SubtitleTextWidget(
                    label:
                        "SubTotal: ${cartProvider.getTotal(productProvider: productsProvider).toStringAsFixed(2)} AED",
                    color: AppColors.goldenColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldenColor,
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
              child: const Text(
                "Check Out",
                style: TextStyle(fontSize: 10,color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
