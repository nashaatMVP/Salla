import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:salla/shared/app/custom_button.dart';
import '../../core/my_app_functions.dart';
import '../../core/validator.dart';
import '../../root_screen.dart';
import '../../shared/app/circular_widget.dart';
import '../../shared/app/constants.dart';
import '../../shared/app/custom_text.dart';
import '../../shared/app/custom_text_field.dart';
import 'forot_password_screen.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  static const routName = "/LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool obscureText = true;
  final auth = FirebaseAuth.instance;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "richsonic@gmail.com");
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
        setState(() => isLoading = true);

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
          MyAppFunctions().globalMassage(context: context, message: "invalid email/password");
        }
      } catch (error) {
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kGap70,
                Center(
                    child: Image.asset("assets/images/logo/logo-bg.png", width: 140),
                ),
                kGap40,
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
                            onPressed: () =>
                                setState(() => obscureText = !obscureText),
                            icon: Icon(
                              size: 18,
                              color: Colors.green.shade600,
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          onFieldSubmitted: (p0) async => await _loginFct(),
                          validator: (value) => MyValidators.passwordValidator(value)),
                      kGap5,
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(context, ForgotPasswordScreen.routeName),
                          child: TextWidgets.bodyText1('Forgot Password ?',color: Colors.black),
                        ),
                      ),
                      kGap5,
                      isLoading ? const Center(child: CupertinoActivityIndicator()) : CustomButton(
                          onPressed: _loginFct,
                          text: "Login",
                          textColor: Colors.white,
                          backgroundColor: Colors.green.shade600,
                      ),
                      kGap10,
                      TextWidgets.bodyText1('or', fontSize: 20),
                      kGap10,
                      CustomButton(
                        onPressed: () async => Navigator.pushNamed(
                          context,
                          RootScreen.routeName,
                        ),
                        text: "Guest ?",
                        textColor: Colors.green.shade600,
                        backgroundColor: Colors.white,
                        borderColor: Colors.black45,
                      ),
                      kGap10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidgets.bodyText1('don\'t have an account ?',fontSize: 15,color: Colors.black),
                          TextButton(
                            child: TextWidgets.bodyText1('register',fontSize: 16,color: Colors.blue.shade900),
                            onPressed: () => Navigator.of(context).pushNamed(RegisterScreen.routName),
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
    );
  }
}
