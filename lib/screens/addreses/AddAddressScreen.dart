import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salla/screens/cart/checkout_screen.dart';
import 'package:salla/shared/app/constants.dart';
import 'package:salla/shared/app/custom_appbar.dart';
import 'package:salla/shared/app/custom_button.dart';
import 'package:salla/shared/app/custom_container.dart';
import 'package:salla/shared/app/custom_text_field.dart';
import 'provider/address_provider.dart';
import '../../core/my_app_functions.dart';
import '../../shared/app/custom_text.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/app/circular_widget.dart';

class AddressEditScreen extends StatefulWidget {
  const AddressEditScreen({super.key, this.flat, this.area, this.town, this.state, this.phoneNumber});
  final String? flat;
  final String? area;
  final String? town;
  final String? state;
  final String? phoneNumber;

  @override
  State<AddressEditScreen> createState() => _AddressEditScreenState();
}

class _AddressEditScreenState extends State<AddressEditScreen> {
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController flatController;
  late TextEditingController areaController;
  late TextEditingController townController;
  late TextEditingController stateController;
  late TextEditingController phoneNumberController;

  late final FocusNode _phoneNumberFocusNode, _flatFocusNode, _areaFocusNode,  _townFocusNode, _stateFocusNode;

  @override
  void initState() {
    ///  field
    flatController = TextEditingController(text: widget.flat ?? '');
    areaController = TextEditingController(text: widget.area ?? '');
    townController = TextEditingController(text: widget.town ?? '');
    stateController = TextEditingController(text: widget.state ?? '');
    phoneNumberController = TextEditingController(text:  widget.phoneNumber ?? '');

    /// focus node
    _phoneNumberFocusNode = FocusNode();
    _flatFocusNode = FocusNode();
    _areaFocusNode = FocusNode();
    _townFocusNode = FocusNode();
    _stateFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      flatController.dispose();
      areaController.dispose();
      townController.dispose();
      stateController.dispose();
      phoneNumberController.dispose();

      /// Focus Nodes
      _flatFocusNode.dispose();
      _areaFocusNode.dispose();
      _townFocusNode.dispose();
      _stateFocusNode.dispose();
      _phoneNumberFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            appBar: CustomAppBar(onDelete: () {}, text: "Add New Address"),
            body: LoadingManager(
                isLoading: isLoading,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              kGap20,
                              IntlPhoneField(
                                showCursor: false,
                                initialCountryCode: "AE",
                                focusNode: _phoneNumberFocusNode,
                                keyboardType: TextInputType.phone,
                                controller: phoneNumberController,
                                dropdownTextStyle: TextStyle(color: appColors.primaryColor),
                                style: TextStyle(
                                  fontSize: 13,
                                  decorationThickness: 0,
                                  color: appColors.primaryColor,
                                ),
                                onSubmitted: (value) => FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(1),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:  BorderSide(color: Colors.grey.shade400),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:  BorderSide(color: Colors.grey.shade200),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.purple),
                                  ),
                                  counterText: '',
                                  fillColor: appColors.secondaryColor,
                                  filled: true,
                                  hintText: "50 5344683",
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                              kGap10,
                              CustomFormField(
                                  controller: areaController,
                                  focusNode: _areaFocusNode,
                                  hintName: "Area",
                                  iconData: Icons.compare_arrows,
                                  onFieldSubmitted: (v) => FocusScope.of(context).requestFocus(_areaFocusNode),
                                  validator: (v) {
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: false,
                              ),
                              kGap10,
                              CustomFormField(
                                obscureText: false,
                                // label:  widget.flat ?? "",
                                focusNode: _flatFocusNode,
                                controller: flatController,
                                iconData: Icons.house_outlined,
                                hintName: "flat , villa , building...",
                                onFieldSubmitted: (v) => FocusScope.of(context).requestFocus(_flatFocusNode),
                                validator: (v) {
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                              ),
                              kGap10,
                              CustomFormField(
                                obscureText: false,
                                controller: townController,
                                focusNode: _townFocusNode,
                                hintName: "Floor Number",
                                iconData: Icons.numbers_outlined,
                                onFieldSubmitted: (v) => FocusScope.of(context).requestFocus(_townFocusNode),
                                validator: (v) {
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                              ),
                              kGap10,
                              CustomFormField(
                                controller: stateController,
                                focusNode: _stateFocusNode,
                                hintName: "State",
                                iconData: Icons.share_location_rounded,
                                onFieldSubmitted: (v) => FocusScope.of(context).requestFocus(_stateFocusNode),
                                validator: (v) {
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                obscureText: false,
                              ),
                              kGap30,
                              CustomButton(
                                  text: "Save",
                                  backgroundColor: appColors.primaryColor,
                                  textColor: appColors.secondaryColor,
                                  onPressed:() async {
                                    final isValid =  _formKey.currentState!.validate();
                                    FocusScope.of(context).unfocus();
                                    if (isValid) {
                                      if (phoneNumberController.text != "" &&
                                          flatController.text != "" &&
                                          areaController.text != "" &&
                                          townController.text != "" &&
                                          stateController.text != "") {
                                        await addressProvider.addToAddressFirebase(
                                            context: context,
                                            phoneNumber: phoneNumberController.text.toString(),
                                            flat: flatController.text,
                                            area: areaController.text,
                                            town: townController.text,
                                            state: stateController.text,
                                        );
                                        // ignore: use_build_context_synchronously
                                        Navigator.pushReplacement(
                                            context, MaterialPageRoute( builder: ((context) => const CheckoutScreen()),
                                            ));
                                      } else {
                                        MyAppFunctions().globalMassage(
                                            context: context,
                                            message: "Please Fill All Fields",
                                        );
                                      }
                                    }
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))),
    );
  }
}
