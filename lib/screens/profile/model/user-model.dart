import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final String? userId, userName, userEmail, userImage;
  final Timestamp createdAt;
  final List? userCart, userWish;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.userImage,
    required this.createdAt,
    required this.userCart,
    required this.userWish,
  });
}
