import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smart_shop/AUTH/forot_password_screen.dart';
import 'package:smart_shop/SERVICES/my_app_functions.dart';
import 'package:smart_shop/WIDGETS/circular_widget.dart';
import 'package:smart_shop/WIDGETS/formfield_widget.dart';
import 'package:smart_shop/WIDGETS/text_widget.dart';
import 'package:smart_shop/core/constants.dart';
import 'package:smart_shop/root_screen.dart';
import '../core/app_colors.dart';
import '../core/validator.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  static const routName = "/LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "nashaat@gmail.com");
    _passwordController = TextEditingController(text: '123456');
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
      _passwordController.dispose();
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _loginFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });

        await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RootScreen()),
        );
      } on FirebaseException catch (e) {
        if (e.code == 'invalid-credential') {
          MyAppFunctions().globalMassage(context: context, message: "IN-VALID EMAIL");
          print("Login Error : ${e.toString()}");
        }
      } catch (error) {
        print("Login Error : ${error.toString()}");

      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.lightPrimary,
        body: LoadingManager(
          isLoading: isLoading,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Column(
                        children: [
                          TitlesTextWidget(
                            label: "Login",
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                          kGap5,
                          SubtitleTextWidget(
                            fontSize: 10,
                            label:
                                "Fill real email & password, don't miss the destiny",
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.1),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            hintName: "Email",
                            iconData: IconlyLight.message,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (p0) => FocusScope.of(context)
                                .requestFocus(_passwordFocusNode),
                            validator: (value) =>
                                MyValidators.emailValidator(value),
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                          ),
                          kGap10,
                          CustomFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            obscureText: obscureText,
                            textInputAction: TextInputAction.next,
                            hintName: "Password",
                            keyboardType: TextInputType.visiblePassword,
                            iconData: IconlyLight.lock,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            onFieldSubmitted: (p0) async {
                              await _loginFct();
                            },
                            validator: (value) =>
                                MyValidators.passwordValidator(value),
                          ),
                          kGap10,
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, ForgotPasswordScreen.routeName);
                              },
                              child: const SubtitleTextWidget(
                                label: "Forgot password?",
                                textDecoration: TextDecoration.underline,
                                color: AppColors.goldenColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          kGap10,
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _loginFct();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: AppColors.goldenColor,
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(fontSize: 15,color: Colors.white),
                              ),
                            ),
                          ),
                          kGap20,
                          const SubtitleTextWidget(
                            label: "or",
                            fontSize: 15,
                          ),
                          kGap15,
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                backgroundColor:
                                    const Color.fromARGB(255, 245, 243, 243),
                                padding: const EdgeInsets.all(12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ),
                                ),
                              ),
                              child: const Text(
                                " Guest ?",
                                style: TextStyle(
                                    fontSize: 15, color: AppColors.goldenColor),
                              ),
                              onPressed: () async {
                                Navigator.pushNamed(
                                  context,
                                  RootScreen.routeName,
                                );
                              },
                            ),
                          ),
                          kGap10,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SubtitleTextWidget(
                                label: "Don't have an account ?",
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 13,
                              ),
                              TextButton(
                                child: const SubtitleTextWidget(
                                  label: "Sign up",
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.goldenColor,
                                  textDecoration: TextDecoration.underline,
                                  fontSize: 13,
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(RegisterScreen.routName);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
