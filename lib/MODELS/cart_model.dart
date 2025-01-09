import 'package:flutter/material.dart';

class CartModel with ChangeNotifier {
  final String cartID;
  final String producttID;
  final int cartQty;

  CartModel(
      {required this.cartID, required this.producttID, required this.cartQty});
}
