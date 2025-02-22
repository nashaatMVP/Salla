import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/address_model.dart';
import '../providers/address_provider.dart';
import '../screens/cart/provider/cart_provider.dart';
import '../providers/products_provider.dart';
import '../screens/profile/provider/user_provider.dart';
import '../shared/app/custom_text.dart';
import '../shared/theme/app_colors.dart';
import '../shared/app/circular_widget.dart';
import '../shared/app/custom_empty_widget.dart';
import '../screens/cart/widgets/cart_widget.dart';
import 'AddAddressScreen.dart';
import 'order_screen.dart';

List<AddressModel> address = [];
String addressesAsString = "";

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({super.key});

  @override
  State<SelectAddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<SelectAddressScreen> {
  bool isLoading = false;
  double shippingFee = 10.00; ///// Shipping Fee

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final addressProvider = Provider.of<AddressProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // ignore: non_constant_identifier_names
    final double Total =
        cartProvider.getTotal(productProvider: productProvider) + shippingFee;
    return cartProvider.getCartItems.isEmpty &&
            addressProvider.getaddress.isEmpty
        ? const Scaffold(
            body: EmptyBagWidget(
              image: "assets/bag/emptyCart.png",
              title: "Your Shopping cart looks empty.",
              subTitle: "what are you waiting for !!",
              buttonTitle: "Shop Now",
            ),
          )
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                toolbarHeight: 35,
                title:  Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextWidgets.bodyText1("CheckOut"),

                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      await cartProvider.clearCartFromFirestore(
                          context: context);
                      cartProvider.clearLocalCart();
                    },
                    icon:  Icon(
                      Icons.clear_all,
                      color: appColors.primaryColor,
                    ),
                  ),
                ],
              ),
              body: LoadingManager(
                isLoading: isLoading,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      ////////////////// Select Address ///////////////////////////
                      addressProvider.getaddress.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                height: addressProvider.getaddress.length * 60,
                                child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        addressProvider.getaddress.length,
                                    itemBuilder: (context, index) {
                                      return ChangeNotifierProvider.value(
                                        value: addressProvider.getaddress.values
                                            .toList()[index],
                                        child: const AddressWidget(),
                                      );
                                    }),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const AddressEditScreen())));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: appColors.primaryColor, width: 2),
                                  ),
                                  child:  Row(
                                    children: [
                                      Icon(
                                        Ionicons.location,
                                        color: appColors.primaryColor
                                        ,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      TextWidgets.bodyText1("Please Add Your Address Information"),

                                      const Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: appColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      //////////////////////Products////////////////
                      SizedBox(
                        height: cartProvider.getCartItems.length *
                            180, // 200 defualt
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartProvider.getCartItems.length,
                            itemBuilder: (context, index) {
                              return ChangeNotifierProvider.value(
                                value: cartProvider.getCartItems.values
                                    .toList()[index],
                                child:  const CartWidget(),
                              );
                            }),
                      ),

                      ///////////////////////////// Order Detailes /////////////////////////////////////////

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ignore: prefer_const_constructors
                              TextWidgets.bodyText1("Order Details"),

                              const SizedBox(
                                height: 14,
                              ),

                              ///Subtotal
                              Row(
                                children: [
                                  TextWidgets.bodyText1("Subtotal : "),
                                  const Spacer(),
                                  TextWidgets.bodyText1("${cartProvider.getTotal(productProvider: productProvider).toStringAsFixed(2)} AED"),

                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),

                              ///Shipping Fee
                              Row(
                                children: [
                                  TextWidgets.bodyText1("Shipping Fee : "),
                                  const Spacer(),
                                  TextWidgets.bodyText1("${shippingFee.toString()} AED"),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Divider(thickness: 1),
                              ///// Total
                              Row(
                                children: [
                                  TextWidgets.bodyText1("Total :"),


                                  const Spacer(),
                                  TextWidgets.bodyText1("${Total.toStringAsFixed(2)} AED"),


                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      /////////////////////////////////    Button   ////////////////////////////////
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: () async {
                            if (addressProvider.SelectedAddresses != "") {
                              await orderPlace(
                                cartProvider: cartProvider,
                                productProvider: productProvider,
                                userProvider: userProvider,
                                addressModel: addressProvider.SelectedAddresses,
                                appColors: appColors,
                              ).then((value) => Navigator.pushNamed(
                                  context, OrdersScreenFree.routeName));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please Select Address"),
                                ),
                              );
                            }
                          },
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: 320,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: appColors.primaryColor,
                                  ),
                                  child: const FittedBox(
                                    child: Text(
                                      "Cash on Delivery",
                                      style:
                                          // ignore: prefer_const_constructors
                                          TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
          "totalPrice": cartProvider.getTotal(productProvider: productProvider),
          "ImageUrl": getCurrentProduct.productImage,
          "quntity": value.cartQty,
          "orderDate": Timestamp.now(),
          "orderStatus": "0",
          "orderAddress": addressModel,
          "totalPrice": shippingFee +
              double.parse(getCurrentProduct.productPrice) * value.cartQty,
        });
      });
      await cartProvider.clearCartFromFirestore(context: context);
      cartProvider.clearLocalCart();
      // ignore: use_build_context_synchronously
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

class AddressWidget extends StatefulWidget {
  const AddressWidget({Key? key}) : super(key: key);

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  @override
  Widget build(BuildContext context) {
    final addressModel = Provider.of<AddressModel>(context);
    final addressProvider = Provider.of<AddressProvider>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;
    return ListTile(
      leading: SizedBox(
        width: 20,
        // margin: const EdgeInsets.only(bottom: 40, left: 10),
        child: Radio<AddressModel>(
          fillColor:
              MaterialStateColor.resolveWith((states) => appColors.primaryColor),
          value: addressModel,
          groupValue: addressProvider.getSelectedAddress(),
          onChanged: (AddressModel? selectedAddress) {
            addressProvider.setSelectedAddress(selectedAddress!);
          },
        ),
      ),
      trailing: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddressEditScreen(),
                ));
          },
          child:  Text(
            "Edit",
            style: TextStyle(color: appColors.primaryColor),
          )),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${addressModel.area}, ${addressModel.flat} ${addressModel.town}, ${addressModel.state}',
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                '+971-${addressModel.phoneNumber}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(
                width: 5,
              ),
               Icon(
                Icons.verified,
                color: appColors.primaryColor,
                size: 14,
              ),
            ],
          ),
          // Add other address fields as needed
        ],
      ),
    );
  }
}
