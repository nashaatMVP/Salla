import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salla/shared/app/circular_widget.dart';
import 'package:salla/shared/app/custom_appbar.dart';
import 'package:salla/shared/app/custom_empty_widget.dart';
import '../../shared/app/constants.dart';
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
              isCart: true,
              title: "Your Shopping cart looks empty.",
              subTitle: "what are you waiting for !!",
              buttonTitle: "Shop Now",
            ),
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              text: "Your Cart (${cartProvider.getCartItems.length})",
              isCart: true,
              onDelete: () async {
              await cartProvider.clearCartFromFirestore(context: context);
              cartProvider.clearLocalCart();
            },
            ),
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
                                const CartWidget(),
                                Divider(height: 20,color: Colors.grey.shade200,thickness: 10),
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
