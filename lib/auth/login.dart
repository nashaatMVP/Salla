import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:smart_shop/root_screen.dart';
import '../core/my_app_functions.dart';
import '../shared/app/circular_widget.dart';
import '../shared/app/constants.dart';
import '../shared/app/custom_text.dart';
import '../shared/app/custom_text_field.dart';
import '../core/validator.dart';
import 'forot_password_screen.dart';
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
                    Center(
                      child: Column(
                        children: [
                          TextWidgets.bodyText1('Login'),
                          kGap5,
                          TextWidgets.bodyText1('Fill real email & password, don\'t miss the destiny'),

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
                              child:  TextWidgets.bodyText1('Forgot Password'),
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
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(fontSize: 15,color: Colors.white),
                              ),
                            ),
                          ),
                          kGap20,
                          TextWidgets.bodyText1('or'),
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
                              child:  Text(
                                " Guest ?",
                                style: TextStyle(
                                    fontSize: 15, ),
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
                              TextWidgets.bodyText1('Dont Have account'),
                              TextButton(
                                child:  TextWidgets.bodyText1('Sign Up'),
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
