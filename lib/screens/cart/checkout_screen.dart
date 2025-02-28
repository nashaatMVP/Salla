import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/screens/addreses/saved_address_screen.dart';
import 'package:smart_shop/shared/app/constants.dart';
import 'package:smart_shop/shared/app/custom_appbar.dart';
import 'package:smart_shop/shared/app/custom_button.dart';
import 'package:smart_shop/shared/app/custom_container.dart';
import 'package:smart_shop/shared/app/custom_divider.dart';
import 'package:uuid/uuid.dart';
import '../addreses/model/address_model.dart';
import '../addreses/provider/address_provider.dart';
import '../addreses/widgets/add_new_address_card.dart';
import 'provider/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../profile/provider/user_provider.dart';
import '../../shared/app/custom_text.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/app/circular_widget.dart';
import '../../shared/app/custom_empty_widget.dart';
import 'widgets/cart_widget.dart';
import '../addreses/AddAddressScreen.dart';
import '../../sideScreens/order_screen.dart';
import 'widgets/payment_options.dart';

List<AddressModel> address = [];
String addressesAsString = "";

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isLoading = false;
  double shippingFee = 10.00;

  /// Shipping Fee
  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final addressProvider = Provider.of<AddressProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // ignore: non_constant_identifier_names
    final double Total =  cartProvider.getTotal(productProvider: productProvider) + shippingFee;
    return cartProvider.getCartItems.isEmpty &&  addressProvider.getaddress.isEmpty
        ? const Scaffold(
            body: EmptyBagWidget(
              isCart: true,
              title: "Your Shopping cart looks empty.",
              subTitle: "what are you waiting for !!",
              buttonTitle: "Shop Now",
            ),
          )
        : Scaffold(
            appBar: CustomAppBar(
              text: "Check out",
              onDelete: () async {
                await cartProvider.clearCartFromFirestore(context: context);
                cartProvider.clearLocalCart();
              },
            ),
            body: LoadingManager(
              isLoading: isLoading,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    kGap15,
                    addressProvider.selectedaddresses.isNotEmpty
                        ? CustomContainer(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0 , bottom: 5),
                            child: Icon(CupertinoIcons.map_pin_ellipse , color: blueColor),
                          ),
                          kGap10,
                          TextWidgets.bodyText(addressProvider.SelectedAddresses,color: appColors.primaryColor),
                          const Spacer(), 
                          TextButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SavedAddressScreen())),
                              child: TextWidgets.bodyText("Change"),
                          ),
                        ],
                      ),
                    )
                        : AddNewAddressCard(
                        onTap: () {
                          if(addressProvider.selectedaddresses.isNotEmpty ) {
                            Navigator.push(context, MaterialPageRoute(builder: (c) => const AddressEditScreen()));
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (c) => const SavedAddressScreen()));
                          }
                        },
                    ),
                    kGap10,
                    const CustomDivider(),
                    kGap10,
                    const PaymentOptions(),
                  ],
                ),
              ),
            ),
            bottomSheet: BottomSheet(
              onClosing: () {},
              builder: (_) => CustomContainer(
                height: 250,
                radius: 20,
                width: double.infinity,
                color: appColors.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kGap20,
                      TextWidgets.subHeading("Order summary", color: appColors.secondaryColor, fontSize: 15),
                      kGap20,
                      Row(
                        children: [
                          TextWidgets.bodyText1("Subtotal : ",
                              color: appColors.secondaryColor),
                          const Spacer(),
                          TextWidgets.bodyText1(
                              "${cartProvider.getTotal(productProvider: productProvider).toStringAsFixed(2)} AED",
                              color: appColors.secondaryColor,
                              fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      kGap5,
                      Row(
                        children: [
                          TextWidgets.bodyText1("Shipping Fee : ",
                              color: appColors.secondaryColor),
                          const Spacer(),
                          TextWidgets.bodyText1("${shippingFee.toString()} AED",color: blueColor , fontWeight: FontWeight.w600),
                        ],
                      ),
                      kGap15,
                      Divider(thickness: 1, color: appColors.secondaryColor),
                      kGap15,
                      Row(
                        children: [
                          TextWidgets.bodyText1("Total :",
                              color: appColors.secondaryColor),
                          kGap10,
                          TextWidgets.subHeading(
                              "${Total.toStringAsFixed(2)} AED",
                              color: appColors.secondaryColor,
                              fontSize: 14),
                          const Spacer(),
                          CustomButton(
                            text: "Place Order",
                            height: 34,
                            fontSize: 13,
                            textColor: appColors.primaryColor,
                            backgroundColor: appColors.secondaryColor,
                            onPressed: () async {
                              if (addressProvider.SelectedAddresses != "") {
                                await orderPlace(
                                  cartProvider: cartProvider,
                                  userProvider: userProvider,
                                  productProvider: productProvider,
                                  addressModel: addressProvider.SelectedAddresses,
                                  appColors: appColors,
                                ).then((value) => Navigator.pushNamed(context, OrdersScreenFree.routeName));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Please Select Address"),
                                  ));
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }



  Future<void> orderPlace({
    required CartProvider cartProvider,
    required ProductProvider productProvider,
    required UserProvider userProvider,
    required String addressModel,
    required AppColors appColors,
  }) async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;
    try {
      setState(() {
        isLoading = true;
      });
      cartProvider.getCartItems.forEach((key, value) async {
        final getCurrentProduct = productProvider.findById(value.producttID);
        final orderId = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection("ordersAdvance")
            .doc(orderId)
            .set({
          "orderId": orderId,
          "userId": uid,
          "productId": value.producttID,
          "productTitle": getCurrentProduct!.productTitle,
          "userName": userProvider.userModel!.userName,
          "price": double.parse(getCurrentProduct.productPrice) * value.cartQty,
          // "totalPrice": cartProvider.getTotal(productProvider: productProvider),
          "ImageUrl": getCurrentProduct.productImage,
          "quntity": value.cartQty,
          "orderDate": Timestamp.now(),
          "orderStatus": "0",
          "orderAddress": addressModel,
          "totalPrice": shippingFee + double.parse(getCurrentProduct.productPrice) * value.cartQty,
        });
      });
      await cartProvider.clearCartFromFirestore(context: context);
      cartProvider.clearLocalCart();
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

