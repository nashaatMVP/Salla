// ignore_for_file: use_build_context_synchronously, constant_pattern_never_matches_value_type

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_shop/AUTH/login.dart';
import 'package:smart_shop/SERVICES/my_app_functions.dart';
import 'package:smart_shop/WIDGETS/circular_widget.dart';
import 'package:smart_shop/WIDGETS/formfield_widget.dart';
import 'package:smart_shop/WIDGETS/picker_widget.dart';
import 'package:smart_shop/WIDGETS/text_widget.dart';
import 'package:smart_shop/root_screen.dart';

import '../CONSTANTS/validator.dart';

class RegisterScreen extends StatefulWidget {
  static const routName = "/RegisterScreen";
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController otpController = TextEditingController();
  GlobalKey formkey = GlobalKey<FormState>();

  late final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _repeatPasswordController;

  late final FocusNode _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _repeatPasswordFocusNode;

  final _formkey = GlobalKey<FormState>();
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

  /////////////////////  Sign In Button  \\\\\\\\\\\\\\\\\\\\\\\\

  Future<void> _registerFCT() async {
    if (_pickedImage == null) {
      MyAppFunctions()
          .globalMassage(context: context, message: "Please Pick an Image");
      return;
    }

    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });
        /////////////////////

        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        final User? user = auth.currentUser;
        final String uid = user!.uid;
        final ref = FirebaseStorage.instance
            .ref()
            .child("usersImage")
            .child("${_emailController.text}.jpg");
        await ref.putFile(File(_pickedImage!.path));
        userImageUrl = await ref.getDownloadURL();

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

        if (!mounted) return;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const RootScreen())));
      } finally {
        setState(() {
          isLoading = false;
          MyAppFunctions().globalMassage(
            context: context,
            message: "Account Created Successfully",
          );
        });
      }
    }
  }

  //////////////////////////////////// Image Picker Method ////////////////////////////////////

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

  ////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: LoadingManager(
          isLoading: isLoading,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),

                  const Center(
                    child: Column(
                      children: [
                        TitlesTextWidget(
                          label: "Create Account",
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SubtitleTextWidget(
                          label:
                              "Fill real information, don't miss the destiny",
                          fontSize: 10,
                          color: Color.fromARGB(255, 30, 29, 29),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  /////////////////////////////////////////  Image Picker  ////////////////////////////////////////////////////
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.width * 0.3,
                        width: size.width * 0.3,
                        child: ImagePickerr(
                          pickedImage: _pickedImage,
                          function: () async {
                            await localImagePicker();
                          },
                        ),
                      ),
                    ],
                  ),
                  /////////////////////////////////////  Form  Form  ///////////////////////////////////////////

                  Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        //////////////////////////////////////////////////////// Name Field ////////////////////////////////////////////////////////////////////////
                        CustomFormField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          hintName: 'User Name',
                          textInputAction: TextInputAction.next,
                          obscureText: false,
                          keyboardType: TextInputType.name,
                          iconData: Icons.person_2_outlined,
                          onFieldSubmitted: (p0) => FocusScope.of(context)
                              .requestFocus(_emailFocusNode),
                          validator: (value) =>
                              MyValidators.displayNamevalidator(value),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        //////////////////////////////////////////////////////// Email Field ////////////////////////////////////////////////////////////////////////

                        CustomFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            textInputAction: TextInputAction.next,
                            hintName: "Email Address",
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            iconData: IconlyLight.message,
                            onFieldSubmitted: (p0) => FocusScope.of(context)
                                .requestFocus(_passwordFocusNode),
                            validator: (value) =>
                                MyValidators.emailValidator(value)),

                        const SizedBox(
                          height: 10.0,
                        ),
                        /////////////////////////////////////////////////////////// Password Field ///////////////////////////////////////////////////////////////////
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
                            FocusScope.of(context)
                                .requestFocus(_repeatPasswordFocusNode);
                          },
                          validator: (value) =>
                              MyValidators.passwordValidator(value),
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        //////////////////////////////////////////////////////////// Repeat Password Field ////////////////////////////////////////////////////////////////
                        CustomFormField(
                            controller: _repeatPasswordController,
                            focusNode: _repeatPasswordFocusNode,
                            obscureText: obscureText,
                            textInputAction: TextInputAction.done,
                            hintName: "Repeat Password",
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
                              await _registerFCT();
                            },
                            validator: (value) {
                              return MyValidators.repeatPasswordValidator(
                                value: value,
                                password: _passwordController.text,
                              );
                            }),
                        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        const SizedBox(
                          height: 20.0,
                        ),

                        /////////////////////////////////////////////////////// Register Button \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              _registerFCT();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.deepPurple,
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(fontSize: 16,color: Colors.white),
                            ),
                          ),
                        ),
                        //////////////////////////////////////////////////////////////////////////////////////////////////////////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SubtitleTextWidget(
                              label: "Already have an account ?",
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    LoginScreen.routName,
                                  );
                                },
                                child: const Text(
                                  "Log in",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 57, 36, 146),
                                    decoration: TextDecoration.underline,
                                  ),
                                )),
                          ],
                        ),

                        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
