import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_shop/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  late ProductModel productModel;
  List<ProductModel> products = [];
  List<ProductModel> get getProduct {
    return products;
  }

  List<ProductModel> productsproductsHorizontal = [];
  List<ProductModel> get getProductproductsHorizontal {
    return productsproductsHorizontal;
  }

  List<ProductModel> productsproductsSecondHorizontal = [];
  List<ProductModel> get getProductproductsSecondHorizontal {
    return productsproductsSecondHorizontal;
  }

  List<ProductModel> productsproductsVertical = [];
  List<ProductModel> get getproductsproductsVertical {
    return productsproductsVertical;
  }

  ProductModel? findById(String productId) {
    if (products.where((element) => element.productID == productId).isEmpty) {
      return null;
    }
    return products.firstWhere((element) => element.productID == productId);
  }

  List<ProductModel> findByCategory({required String categoryName}) {
    List<ProductModel> categoryList = products
        .where((element) => element.productcategory.toLowerCase().contains(
              categoryName.toLowerCase(),
            ))
        .toList();
    return categoryList;
  }

  List<ProductModel> searchQuery({required String searchText}) {
    List<ProductModel> searchList = products
        .where((element) => element.productcategory.toLowerCase().contains(
              searchText.toLowerCase(),
            ))
        .toList();
    return searchList;
  }

  List<ProductModel> searchTitle({required String searchText}) {
    List<ProductModel> searchList = products
        .where((element) => element.productTitle.toLowerCase().contains(
              searchText.toLowerCase(),
            ))
        .toList();
    return searchList;
  }

  final productDb = FirebaseFirestore.instance.collection("products");
  Future<List<ProductModel>> fetchProducts() async {
    try {
      await productDb
          .orderBy("createdAt", descending: false)
          .get()
          .then((productSnapshot) {
        products.clear();
        // products = []
        for (var element in productSnapshot.docs) {
          products.insert(0, ProductModel.fromFirestore(element));
        }
      });
      notifyListeners();
      return products;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ProductModel>> fetchproductStream() {
    try {
      return productDb.snapshots().map((snapshot) {
        products.clear();
        // products = []
        for (var element in snapshot.docs) {
          products.insert(0, ProductModel.fromFirestore(element));
        }

        return products;
      });
    } catch (e) {
      rethrow;
    }
  }

  ////////////////////// New Arrival
  Future<List<ProductModel>> fetchProductsHorizontal() async {
    try {
      await productDb
          .where("productDirection", isEqualTo: "New Arrival")
          .orderBy("createdAt", descending: false)
          .get()
          .then((productSnapshot) {
        productsproductsHorizontal.clear();
        // products = []
        for (var element in productSnapshot.docs) {
          productsproductsHorizontal.insert(
              0, ProductModel.fromFirestore(element));
        }
      });
      notifyListeners();
      return productsproductsHorizontal;
    } catch (e) {
      rethrow;
    }
  }

  ////////////////////// Latest Arrival Two
  Future<List<ProductModel>> fetchProductsSecondHorizontal() async {
    try {
      await productDb
          .where("productDirection", isEqualTo: "Latest Arrival Two")
          .orderBy("createdAt", descending: false)
          .get()
          .then((productSnapshot) {
        productsproductsSecondHorizontal.clear();
        // products = []
        for (var element in productSnapshot.docs) {
          productsproductsSecondHorizontal.insert(
              0, ProductModel.fromFirestore(element));
        }
      });
      notifyListeners();
      return productsproductsSecondHorizontal;
    } catch (e) {
      rethrow;
    }
  }

  ////////////////////// Recommanded for you
  Future<List<ProductModel>> fetchProductsVertical() async {
    try {
      await productDb
          .where("productDirection", isEqualTo: "Recommanded for you")
          .orderBy("createdAt", descending: false)
          .get()
          .then((productSnapshot) {
        productsproductsVertical.clear();
        // products = []
        for (var element in productSnapshot.docs) {
          productsproductsVertical.insert(
              0, ProductModel.fromFirestore(element));
        }
      });
      notifyListeners();
      return productsproductsVertical;
    } catch (e) {
      rethrow;
    }
  }

  //////////////////////  get Offer

  double getOffer() {
    double total = double.parse(productModel.productOldPrice!) /
        double.parse(productModel.productPrice);
    return total;
  }
}
