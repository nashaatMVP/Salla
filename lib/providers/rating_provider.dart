import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/rating_model.dart';

class RatingProvider with ChangeNotifier {
  final List<RatingModelAdvanced> review = [];

  List<RatingModelAdvanced> get getreviews => review;

  Future<List<RatingModelAdvanced>> fetchproductreview(String productid) async {
    try {
      await FirebaseFirestore.instance
          .collection("ProductRating")
          .where("productId", isEqualTo: productid)
          .get()
          // ignore: non_constant_identifier_names
          .then((Snapshot) {
        review.clear();
        for (var element in Snapshot.docs) {
          var data = element.data();
          inspect(data);

          review.insert(
            0,
            RatingModelAdvanced(
              element.get("orderid"),
              element.get("userId"),
              element.get("productId"),
              element.get("ratingid"),
              element.get("rating").toString(),
              element.get("Review"),
              element.get("titleReview"),
            ),
          );
        }
      });
      print(review);
      return review;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        // User details found, return the user data as a Map
        return userSnapshot.data() as Map<String, dynamic>;
      } else {
        // User not found or details are missing
        return {}; // Return an empty Map or null based on your handling
      }
    } catch (e) {
      // Handle any errors that occur during fetching user details
      print("Error fetching user details: $e");
      return {}; // Return an empty Map or null based on your handling
    }
  }
}
