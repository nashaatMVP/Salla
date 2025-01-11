import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_shop/MODELS/cart_model.dart';
import 'package:smart_shop/PROVIDERS/products_provider.dart';
import 'package:smart_shop/SERVICES/my_app_functions.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

  final userstDb = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
////////////////////////////////////////////// Firebase \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  Future<void> addToCartFirebase({
    required String productId,
    required int qty,
    required BuildContext context,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      MyAppFunctions()
          .globalMassage(context: context, message: "Please Login First");
      return;
    }
    final uid = user.uid;
    final cartId = const Uuid().v4();
    try {
      await userstDb.doc(uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': qty,
          }
        ])
      });
      await fetchCart();
      MyAppFunctions()
          .globalMassage(context: context, message: "Item Added To Cart");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchCart() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      _cartItems.clear();
      return;
    }
    try {
      final userDoc = await userstDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("userCart")) {
        return;
      }
      final leg = userDoc.get("userCart").length;
      for (int index = 0; index < leg; index++) {
        _cartItems.putIfAbsent(
            userDoc.get("userCart")[index]["productId"],
            () => CartModel(
                cartID: userDoc.get("userCart")[index]["cartId"],
                producttID: userDoc.get("userCart")[index]["productId"],
                cartQty: userDoc.get("userCart")[index]["quantity"]));
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeCartItemFromFirestor(
      {required String cartId,
      required String productId,
      required context,
      required int qty}) async {
    final User? user = _auth.currentUser;
    try {
      await userstDb.doc(user!.uid).update({
        'userCart': FieldValue.arrayRemove([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': qty,
          }
        ])
      });
      // await fetchCart();
      _cartItems.remove(productId);
      MyAppFunctions().globalMassage(
          context: context, message: "Item Removed Successfully");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearCartFromFirestore({required context}) async {
    final User? user = _auth.currentUser;
    try {
      await userstDb.doc(user!.uid).update({
        'userCart': [],
      });
      // await fetchCart();
      _cartItems.clear();
      MyAppFunctions()
          .globalMassage(context: context, message: "Cart Cleard Successfully");
    } catch (e) {
      rethrow;
    }
  }

// Local
  void addProductToCart({required String productId}) {
    _cartItems.putIfAbsent(
      productId,
      () => CartModel(
          cartID: const Uuid().v4(), producttID: productId, cartQty: 1),
    );
    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  void updateQty({required int Qty, required String productId}) {
    _cartItems.update(
      productId,
      (cartItem) => CartModel(
        cartID: cartItem.cartID,
        producttID: productId,
        cartQty: Qty,
      ),
    );
    notifyListeners();
  }

  bool isProdInCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  double getTotal({required ProductProvider productProvider}) {
    double total = 0.0;
    _cartItems.forEach((key, value) {
      final getCurrentProduct = productProvider.findById(value.producttID);
      if (getCurrentProduct == null) {
        total += 0;
      } else {
        total += double.parse(getCurrentProduct.productPrice) * value.cartQty;
      }
    });
    return total;
  }

  int getQty() {
    int total = 0;
    _cartItems.forEach((key, value) {
      total += value.cartQty;
    });
    return total;
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void removeOneItem({required productId}) {
    _cartItems.remove(productId);
    notifyListeners();
  }
}
