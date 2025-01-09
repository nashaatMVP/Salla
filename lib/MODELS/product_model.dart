import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final String productID,
      productTitle,
      productDescreption,
      productPrice,
      productcategory,
      productQty,
      productdirection,
      productImage;
  final String? productOldPrice;
  final double? productrating;
  final Timestamp? createdAt;

  ProductModel({
    required this.productID,
    required this.productTitle,
    required this.productDescreption,
    required this.productPrice,
    required this.productcategory,
    required this.productQty,
    required this.productImage,
    required this.productdirection,
    this.productrating,
    this.productOldPrice,
    this.createdAt,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    double? producttotalrating = data.containsKey("TotalproductRating")
        ? data["TotalproductRating"]
        : 0.0; // Use an empt
    // data.containsKey("")
    return ProductModel(
      productID: data["productId"],
      productTitle: data['productTitle'],
      productPrice: data['productPrice'],
      productcategory: data['productCategory'],
      productDescreption: data['productDescription'],
      productImage: data['productImage'],
      productQty: data['productQuantity'],
      productdirection: data['productDirection'] ?? "",
      productrating: producttotalrating,
      productOldPrice: data['oldPrice'],
      createdAt: data['createdAt'],
    );
  }
}
