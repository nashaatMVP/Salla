import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/shared/circular_widget.dart';
import 'package:smart_shop/shared/custom_empty_widget.dart';
import '../providers/cart_provider.dart';
import '../shared/custom_text.dart';
import '../shared/theme/app_colors.dart';
import '../widgets/checkout_widget.dart';
import '../widgets/itemWidgets/cart_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final cartProvider = Provider.of<CartProvider>(context);
    return cartProvider.getCartItems.isEmpty
        ? const Scaffold(
            body: EmptyBagWidget(
              image: "assets/bag/emptyCart.png",
              title: "Your Shopping cart looks empty.",
              subTitle: "what are you waiting for !!",
              buttonTitle: "Shop Now",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              toolbarHeight: 35,
              title:  Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: TextWidgets.bodyText1("You Cart"),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await cartProvider.clearCartFromFirestore(context: context);
                    cartProvider.clearLocalCart();
                  },
                  icon:  Icon(
                    Icons.clear_all,
                    color: appColors.primaryColor,
                  ),
                ),
              ],
            ),
            body: LoadingManager(
              isLoading: isLoading,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: cartProvider.getCartItems.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                            value: cartProvider.getCartItems.values
                                .toList()[index],
                            child: const CartWidget(),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: kBottomNavigationBarHeight + 40,
                  ),
                ],
              ),
            ),
            bottomSheet: const CartBottomSheetWidget(),
          );
  }
}
