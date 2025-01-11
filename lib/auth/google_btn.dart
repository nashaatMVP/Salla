import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smart_shop/root_screen.dart';

import '../core/app_colors.dart';

class GoogleButton extends StatefulWidget {
  const GoogleButton({super.key});

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  bool isLoading = false;
  Future<void> _googleSignSignIn({required BuildContext context}) async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleAccount = await googleSignIn.signIn();
      if (googleAccount != null) {
        final googleAuth = await googleAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final authResults = await FirebaseAuth.instance
              .signInWithCredential(GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ));
          final User? user = FirebaseAuth.instance.currentUser;
          final String uid = user!.uid;
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            "userId": authResults.user!.uid,
            "userName": authResults.user!.displayName,
            "userImage": authResults.user!.photoURL,
            "userEmail": authResults.user!.email,
            "userCart": [],
            "userWish": [],
            "Address": [],
            "createdAt": Timestamp.now(),
          });
        }
      }

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(
        context,
        RootScreen.routeName,
      );

      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //   Navigator.pushReplacementNamed(context, RootScreen.routeName);
      //   MyAppFunctions().globalMassage(context: context, message: "Succefully");
      // });
    } on FirebaseException {
      // print(error.message.toString());
    } catch (error) {
      // ignore: use_build_context_synchronously
      // print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12.0),
        backgroundColor: AppColors.goldenColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
      ),
      icon: const Icon(
        Ionicons.logo_google,
        color: Colors.white,
      ),
      label: const Text(
        "Sign with google",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
      onPressed: () async {
        await _googleSignSignIn(context: context);
        // ignore: use_build_context_synchronously
      },
    );
  }
}
