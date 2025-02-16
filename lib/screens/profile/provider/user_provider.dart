import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/user-model.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  UserModel? get getUserModel {
    return userModel;
  }

  Future<UserModel?> deleteUserInfo() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    await FirebaseAuth.instance.currentUser!.delete();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .delete();
    return null;
  }

  Future<UserModel?> fetchUserInfo() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return null;
    }
    String uid = user.uid;
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      final userDocDict = userDoc.data();
      userModel = UserModel(
        userId: userDoc.get("userId"),
        userName: userDoc.get("userName"),
        userImage: userDocDict!.containsKey("userImage")
            ? userDoc.get("userImage")
            : "",
        userEmail: userDoc.get('userEmail'),
        userCart:
            userDocDict.containsKey("userCart") ? userDoc.get("userCart") : [],
        userWish:
            userDocDict.containsKey("userWish") ? userDoc.get("userWish") : [],
        createdAt: userDoc.get('createdAt'),
      );
      return userModel;
    } on FirebaseException {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }
}
