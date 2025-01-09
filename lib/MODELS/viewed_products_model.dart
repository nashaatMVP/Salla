import 'package:flutter/material.dart';

class ViewedProductModel with ChangeNotifier {
  final String viewedProductID;
  final String producttID;

  ViewedProductModel({
    required this.viewedProductID,
    required this.producttID,
  });
}
