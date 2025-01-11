import 'package:flutter/material.dart';

class RatingModelAdvanced with ChangeNotifier {
  final String orderId;
  final String userId;
  final String productId;
  final String ratingId;
  final String rating;
  final String review;
  final String titlereview;

  RatingModelAdvanced(
    this.orderId,
    this.userId,
    this.productId,
    this.ratingId,
    this.rating,
    this.review,
    this.titlereview,
  );
}
