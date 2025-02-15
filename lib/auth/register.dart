// ignore_for_file: use_build_context_synchronously, constant_pattern_never_matches_value_type
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_shop/auth/login.dart';
import 'package:smart_shop/root_screen.dart';
import '../core/my_app_functions.dart';
import '../shared/circular_widget.dart';
import '../shared/constants.dart';
import '../shared/custom_text.dart';
import '../shared/custom_text_field.dart';
import '../shared/theme/app_colors.dart';
import '../core/validator.dart';
import '../widgets/picker_widget.dart';

class RegisterScreen extends StatefulWidget {
  static const routName = "/RegisterScreen";
  const RegisterScreen({super.key});

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

  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  String? userImageUrl;
  bool obscureText = true;

  @override
  void initState() {
    _nameController = TextEditingController(text: 'Salla');
    _emailController = TextEditingController(text: "Salla@gmail.com");
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
    Size size = MediaQuery.of(context).size;
    final appColors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: appColors.primaryColor,
        body: LoadingManager(
          isLoading: isLoading,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  SizedBox(height: size.height * 0.2),

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
                          onFieldSubmitted: (p0) => FocusScope.of(context)
                              .requestFocus(_emailFocusNode),
                          validator: (value) =>
                              MyValidators.displayNamevalidator(value),
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
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,

                                color: obscureText
                                ? Colors.grey
                                : appColors.primaryColor,
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
                        kGap20,

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              _registerFCT();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.deepPurple,
                            ),
                            child: const Text(
                              "Done",
                              style: TextStyle(fontSize: 16,color: Colors.white),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidgets.bodyText1(' Already Have An Account ?'),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    LoginScreen.routName,
                                  );
                                },
                                child: TextWidgets.bodyText1('Log in'),
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
    );
  }
}
