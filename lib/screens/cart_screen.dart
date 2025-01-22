import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/WIDGETS/checkout_widget.dart';
import 'package:smart_shop/WIDGETS/circular_widget.dart';
import 'package:smart_shop/WIDGETS/empty_widget.dart';
import '../PROVIDERS/cart_provider.dart';
import '../core/app_colors.dart';
import '../core/text_widget.dart';
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
              title: const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: TitlesTextWidget(
                  label: "Your Cart",
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await cartProvider.clearCartFromFirestore(context: context);
                    cartProvider.clearLocalCart();
                  },
                  icon: const Icon(
                    Icons.clear_all,
                    color: AppColors.goldenColor,
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
