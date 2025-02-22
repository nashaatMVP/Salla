import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/screens/cart/model/cart_model.dart';
import 'package:smart_shop/screens/cart/provider/cart_provider.dart';
import '../../../providers/products_provider.dart';
import '../../../shared/app/custom_container.dart';
import '../../../shared/theme/app_colors.dart';

class QtyWidget extends StatelessWidget {
  const QtyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final productsProvider = Provider.of<ProductProvider>(context);
    final stockValue = productsProvider.findById(cartModel.producttID)?.productQty;
    return CustomContainer(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      color: blueColor,
      radius: 30,
      borderColor: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
         cartModel.cartQty == 1  ?  const Icon(
           CupertinoIcons.delete,
           size: 22,
           color: Colors.grey,
         )  : const Text(
                "-",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
             () {
            if (cartModel.cartQty > 1) {
              cartProvider.updateQty(
                  Qty: cartModel.cartQty - 1, productId: cartModel.producttID);
            } else {
              cartProvider.removeOneItem(productId: cartModel.producttID);
              cartProvider.removeCartItemFromFirestor(
                cartId: cartModel.cartID,
                productId: cartModel.producttID,
                context: context,
                qty: cartModel.cartQty,
              );
            }
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "${cartModel.cartQty}",
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
          _buildButton(const Text(
                "+",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ), () {
            if(stockValue == cartModel.cartQty.toString()) {
              return;
            } else {
              cartProvider.updateQty(Qty: cartModel.cartQty + 1, productId: cartModel.producttID);
            }
          },
          ),
        ],
      ),
    );
  }
}


/// Delete Widget
class DeleteWidget extends StatelessWidget {
  const DeleteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return CustomContainer(
      width: 36,
      radius: 10,
      height: 40,
      color: blueColor,
      child: IconButton(
        onPressed: () {
          cartProvider.removeOneItem(productId: cartModel.producttID);
          cartProvider.removeCartItemFromFirestor(
            cartId: cartModel.cartID,
            productId: cartModel.producttID,
            context: context,
            qty: cartModel.cartQty,
          );
        },
        icon:  const Icon(
          size: 22,
          color: Colors.white,
          CupertinoIcons.delete,
        ),
      ),
    );
  }
}

Widget _buildButton(Widget symbol, VoidCallback onPressed) {
  return Material(
    elevation: 2,
    borderRadius: BorderRadius.circular(100),
    color: yellowColor,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(4),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      child: symbol,
    ),
  );
}
