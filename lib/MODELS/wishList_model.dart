import 'package:flutter/material.dart';

class WishListModel with ChangeNotifier {
  final String wishListID;
  final String producttID;

  WishListModel({
    required this.wishListID,
    required this.producttID,
  });
}
