import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:salla/shared/app/custom_text.dart';

import '../../core/validator.dart';
import '../../shared/theme/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgotPasswordScreen';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  late final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
    }
    super.dispose();
  }

  Future<void> _forgetPassFCT() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      auth
          .sendPasswordResetEmail(email: _emailController.text.toString())
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("We have Sent you email to recover")),
        );
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              // Section 1 - Header
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                "assets/forgot_password.jpg",
                width: size.width * 0.6,
                height: size.width * 0.6,
              ),
              const SizedBox(
                height: 10,
              ),
              TextWidgets.bodyText1('Forgot password'),
              TextWidgets.bodyText3('Please enter the email address you\'d like your  \n password reset information sent to'),

              const SizedBox(
                height: 40,
              ),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:  BorderSide(
                                  color: appColors.primaryColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:  BorderSide(
                                  color: appColors.primaryColor)),
                          labelText: 'Enter Email',
                          labelStyle:
                               TextStyle(color: appColors.primaryColor),
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(12),
                            child:  Icon(
                              IconlyLight.message,
                              color: appColors.primaryColor,
                            ),
                          ),
                          hintStyle: const TextStyle(fontSize: 15),
                          filled: true,
                        ),
                        validator: (value) {
                          return MyValidators.emailValidator(value);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _forgetPassFCT();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 40,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: appColors.primaryColor,
                  ),
                  label: const Text("Request Link"),
                  icon: const Icon(Icons.email),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
