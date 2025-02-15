import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/shared/circular_widget.dart';
import 'package:smart_shop/shared/constants.dart';
import 'package:smart_shop/shared/custom_appbar.dart';
import 'package:smart_shop/shared/custom_empty_widget.dart';
import 'provider/cart_provider.dart';
import 'widgets/checkout_widget.dart';
import 'widgets/cart_widget.dart';

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
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              onDelete: () async {
              await cartProvider.clearCartFromFirestore(context: context);
              cartProvider.clearLocalCart();
            },),
            body: LoadingManager(
              isLoading: isLoading,
              child: Column(
                children: [
                  kGap20,
                  Expanded(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: cartProvider.getCartItems.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                            value: cartProvider.getCartItems.values.toList()[index],
                            child:  Column(
                              children: [
                                CartWidget(),
                                Divider(height: 20,color: Colors.grey.shade300,thickness: 10),
                              ],
                            ),
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
