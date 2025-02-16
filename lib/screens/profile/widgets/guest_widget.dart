import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_shop/shared/app/custom_text.dart';
import '../../../AUTH/login.dart';
import '../../../AUTH/register.dart';
import '../../../shared/app/constants.dart';


class GuestWidget extends StatelessWidget {
  const GuestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        kGap20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                      const RegisterScreen()))),
              child: TextWidgets.subHeading("Signup")
            ),

            TextWidgets.subHeading("OR"),

            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                      const LoginScreen()))),
              child: TextWidgets.subHeading("Login")
            ),
          ],
        ),
      ],
    );
  }
}
