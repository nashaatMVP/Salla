import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/sideScreens/select_address_screen.dart';
import '../providers/address_provider.dart';
import '../core/my_app_functions.dart';
import '../shared/custom_text.dart';
import '../shared/theme/app_colors.dart';
import '../shared/circular_widget.dart';

class AddressEditScreen extends StatefulWidget {
  const AddressEditScreen({super.key});
  static const routName = "/AddressEditScreen";
  @override
  State<AddressEditScreen> createState() => _AddressEditScreenState();
}

class _AddressEditScreenState extends State<AddressEditScreen> {
  late final TextEditingController _phonenumberController,
      _flatController,
      _areaController,
      _townController,
      _stateController,
      _landMarkController;

  late final FocusNode _phonenumberFocusNode,
      _flatFocusNode,
      _areaFocusNode,
      _landMarkFocusNode,
      _townFocusNode,
      _stateFocusNode,
      _pinFocusNode;

  final _formkey = GlobalKey<FormState>();

  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _phonenumberController = TextEditingController();
    _flatController = TextEditingController();
    _areaController = TextEditingController();
    // _pinController = TextEditingController();
    _townController = TextEditingController();
    _stateController = TextEditingController();
    // _landMarkController = TextEditingController();
    // Focus Nodes
    _phonenumberFocusNode = FocusNode();
    _flatFocusNode = FocusNode();
    _areaFocusNode = FocusNode();
    _townFocusNode = FocusNode();
    _stateFocusNode = FocusNode();
    // _pinFocusNode = FocusNode();
    // _landMarkFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _phonenumberController.dispose();
      _flatController.dispose();
      _areaController.dispose();
      // _pinController.dispose();
      _townController.dispose();
      _stateController.dispose();
      // _landMarkController.dispose();

      // Focus Nodes
      _phonenumberFocusNode.dispose();
      _flatFocusNode.dispose();
      _areaFocusNode.dispose();
      _townFocusNode.dispose();
      _stateFocusNode.dispose();
      // _pinFocusNode.dispose();
      // _landMarkFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            body: LoadingManager(
                isLoading: isLoading,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /////////////////User Information////////////////////

                        const SizedBox(
                          height: 40,
                        ),
                         Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Ionicons.location,
                                    size: 8,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  TextWidgets.bodyText1("Location Information"),

                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 5.0,
                              ),
                              ///////////////////////////// PHONE NUMBER ///////////////////////////////////////////////
                              IntlPhoneField(
                                controller: _phonenumberController,
                                focusNode: _phonenumberFocusNode,
                                keyboardType: TextInputType.phone,
                                initialCountryCode: "AE",
                                style: const TextStyle(
                                  fontSize: 15,
                                  decorationThickness: 0,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  hintText: 'Phone Number',
                                  hintStyle: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),

                                onSubmitted: (value) {
                                  print(_phonenumberController.text);
                                  FocusScope.of(context)
                                      .requestFocus(_phonenumberFocusNode);
                                },
                                // validator: (value) {
                                //   return MyValidators.phoneValidator(value);
                                // },
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              ////////////////////////////////////////Area//////////////////////////////////////////////////

                              TextFormField(
                                controller: _areaController,
                                focusNode: _areaFocusNode,
                                style: const TextStyle(
                                  fontSize: 15,
                                  decorationThickness: 0,
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  hintText: " Area ",
                                  hintStyle: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(_areaFocusNode);
                                },
                                // validator: (value) {
                                //   return MyValidators.emailValidator(value);
                                // },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              //////////////////////////////Flat or Villa///////////////////////////////////////////////////
                              TextFormField(
                                controller: _flatController,
                                focusNode: _flatFocusNode,
                                style: const TextStyle(
                                  fontSize: 15,
                                  decorationThickness: 0,
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  hintText:
                                      " (Flat or Villa or Company or Building) + Number",
                                  hintStyle: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  // prefixIcon: const Icon(
                                  //   IconlyLight.lock,
                                  //   color: AppColors.goldenColor,
                                  // ),
                                ),
                                onFieldSubmitted: (value) async {
                                  FocusScope.of(context)
                                      .requestFocus(_flatFocusNode);
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ////////////////////////////////////////////////// Floor Number /////////////////////////
                              TextFormField(
                                controller: _townController,
                                focusNode: _townFocusNode,
                                style: const TextStyle(
                                  fontSize: 15,
                                  decorationThickness: 0,
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  hintText: 'Floor Number',
                                  hintStyle: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(_townFocusNode);
                                },
                                // validator: (value) {
                                //   return MyValidators.displayNamevalidator(value);
                                // },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _stateController,
                                focusNode: _stateFocusNode,
                                style: const TextStyle(
                                  fontSize: 15,
                                  decorationThickness: 0,
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  hintText: 'State',
                                  hintStyle: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(_phonenumberFocusNode);
                                },
                                // validator: (value) {
                                //   return MyValidators.displayNamevalidator(value);
                                // },
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final isValid =
                                      _formkey.currentState!.validate();
                                  FocusScope.of(context).unfocus();
                                  if (isValid) {
                                    if (_phonenumberController.text != "" &&
                                        _flatController.text != "" &&
                                        _areaController.text != "" &&
                                        _townController.text != "" &&
                                        _stateController.text != "") {
                                      await addressProvider
                                          .addToAddressFirebase(
                                              phoneNumber:
                                                  _phonenumberController.text
                                                      .toString(),
                                              flat: _flatController.text,
                                              area: _areaController.text,
                                              town: _townController.text,
                                              state: _stateController.text,
                                              context: context);
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  const SelectAddressScreen())));
                                    } else {
                                      MyAppFunctions().globalMassage(
                                          context: context,
                                          message: "Please Fill All Fields");
                                    }
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 55,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: appColors.primaryColor,
                                      ),
                                      child: const Text(
                                        " Submit ",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}
