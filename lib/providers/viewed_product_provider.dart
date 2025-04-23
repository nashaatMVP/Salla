import 'package:flutter/material.dart';
import 'package:salla/MODELS/viewed_products_model.dart';
import 'package:uuid/uuid.dart';

class ViewedProductProvider with ChangeNotifier {
  final Map<String, ViewedProductModel> _viewedProductItems = {};

  Map<String, ViewedProductModel> get getViewedProductItems {
    return _viewedProductItems;
  }

  void addViewedProduct({required String productId}) {
    _viewedProductItems.putIfAbsent(
      productId,
      () => ViewedProductModel(
          viewedProductID: const Uuid().v4(), producttID: productId),
    );

    notifyListeners();
  }

  bool isProdInViewedProduct({required String productId}) {
    return _viewedProductItems.containsKey(productId);
  }

  void clearLocalViewedProduct() {
    _viewedProductItems.clear();
    notifyListeners();
  }
}
