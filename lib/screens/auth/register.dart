// ignore_for_file: use_build_context_synchronously, constant_pattern_never_matches_value_type
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salla/shared/app/custom_button.dart';
import '../../components/picker_widget.dart';
import '../../core/my_app_functions.dart';
import '../../core/validator.dart';
import '../../root_screen.dart';
import '../../shared/app/circular_widget.dart';
import '../../shared/app/constants.dart';
import '../../shared/app/custom_text.dart';
import '../../shared/app/custom_text_field.dart';
import '../../shared/theme/app_colors.dart';
import 'login.dart' show LoginScreen;

class RegisterScreen extends StatefulWidget {
  static const routName = "/RegisterScreen";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController otpController = TextEditingController();
  GlobalKey formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _repeatPasswordController;

  late final FocusNode _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _repeatPasswordFocusNode;

  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  String? userImageUrl;
  bool obscureText = true;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    // Focus Nodes
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _repeatPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _nameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      _repeatPasswordController.dispose();
      // Focus Nodes
      _nameFocusNode.dispose();
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
      _repeatPasswordFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _registerFCT() async {
    if (_pickedImage == null) {
      MyAppFunctions().globalMassage(context: context, message: "Please Pick an Image");
      return;
    }

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });

        try {
          await auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
        } on FirebaseAuthException catch (authError) {
          setState(() {
            isLoading = false;
          });
          MyAppFunctions().globalMassage(
            context: context,
            message: "${authError.message}",
          );
          return;
        }

        final User? user = auth.currentUser;
        final String uid = user!.uid;

        try {
          final ref = FirebaseStorage.instance
              .ref()
              .child("usersImage")
              .child("${_emailController.text}.jpg");
          await ref.putFile(File(_pickedImage!.path));
          userImageUrl = await ref.getDownloadURL();
        } on FirebaseException catch (storageError) {
          setState(() {
            isLoading = false;
          });
          MyAppFunctions().globalMassage(
            context: context,
            message: "Image Upload Error: ${storageError.message}",
          );
          return;
        }

        try {
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            "userId": uid,
            "userName": _nameController.text,
            "userImage": userImageUrl,
            "userEmail": _emailController.text.toLowerCase(),
            "userCart": [],
            "userWish": [],
            "Address": [],
            "createdAt": Timestamp.now(),
          });
        } on FirebaseException catch (error) {
          setState(() {
            isLoading = false;
          });
          MyAppFunctions().globalMassage(
            context: context,
            message: "FireStore Error: ${error.message}",
          );
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RootScreen()),
        );

        MyAppFunctions().globalMassage(
          context: context,
          message: "Account Created Successfully",
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        MyAppFunctions().globalMassage(
          context: context,
          message: "Error: $e",
        );
        print("Error: $e");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  Future<void> localImagePicker() async {
    final ImagePicker imagePicker = ImagePicker();
    await MyAppFunctions.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFCT: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                kGap100,
                kGap20,
                ImagePickerr(
                  pickedImage: _pickedImage,
                  function: () async => await localImagePicker(),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      kGap10,
                      CustomFormField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        hintName: 'User Name',
                        textInputAction: TextInputAction.next,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                        iconData: Icons.person_2_outlined,
                        validator: (value) => MyValidators.displayNamevalidator(value),
                        onFieldSubmitted: (p0) => FocusScope.of(context).requestFocus(_emailFocusNode),
                      ),
                      kGap10,
                      CustomFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          hintName: "Email Address",
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          iconData: IconlyLight.message,
                          onFieldSubmitted: (p0) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                          validator: (value) =>MyValidators.emailValidator(value)),
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
                            size: 19,
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        onFieldSubmitted: (p0) async {FocusScope.of(context).requestFocus(_repeatPasswordFocusNode);},
                        validator: (value) => MyValidators.passwordValidator(value),
                      ),
                      kGap10,
                      CustomFormField(
                          controller: _repeatPasswordController,
                          focusNode: _repeatPasswordFocusNode,
                          obscureText: obscureText,
                          textInputAction: TextInputAction.done,
                          hintName: "Repeat Password",
                          keyboardType: TextInputType.visiblePassword,
                          iconData: IconlyLight.lock,
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => obscureText = !obscureText),
                            icon: Icon(
                              size: 19,
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: obscureText
                              ? Colors.grey
                              : blueColor,
                            ),
                          ),
                          onFieldSubmitted: (p0) async => await _registerFCT(),
                          validator: (value) => MyValidators.repeatPasswordValidator(
                            value: value,
                            password: _passwordController.text,
                          ),
                      ),
                      kGap20,
                      CustomButton(
                          onPressed: _registerFCT,
                          text: 'Sign Up',
                          textColor: Colors.white,
                          backgroundColor: Colors.green.shade600,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidgets.bodyText1('Already Have An Account ?',fontSize: 15,color: Colors.black),
                          TextButton(
                            child: TextWidgets.bodyText1('Login',fontSize: 16,color: Colors.blue.shade900),
                            onPressed: () => Navigator.of(context).pushNamed(LoginScreen.routName),
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
