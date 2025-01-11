import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_shop/MODELS/order_model.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModelAdvanced> orders = [];

  List<OrderModelAdvanced> get getOrders => orders;

  Stream<List<OrderModelAdvanced>> fetchOrdersStream() {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final uid = user!.uid;

    return FirebaseFirestore.instance
        .collection("ordersAdvance")
        .where("userId", isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot orderSnapshot) {
      List<OrderModelAdvanced> orders = [];
      for (var doc in orderSnapshot.docs) {
        orders.add(OrderModelAdvanced.fromFirestore(doc));
      }
      return orders;
    });
  }

  void removeOneItem({required productId}) {
    orders.remove(productId);
    notifyListeners();
  }
}
