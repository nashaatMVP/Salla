import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/MODELS/address_model.dart';
import 'package:smart_shop/PROVIDERS/address_provider.dart';
import 'package:smart_shop/SIDE%20SCREENS/order_screen.dart';
import 'package:smart_shop/WIDGETS/text_widget.dart';
import 'package:uuid/uuid.dart';
import '../PROVIDERS/cart_provider.dart';
import '../PROVIDERS/products_provider.dart';
import '../PROVIDERS/user_provider.dart';
import '../WIDGETS/ITEM WIDGETS/cart_widget.dart';
import '../WIDGETS/circular_widget.dart';
import '../WIDGETS/empty_widget.dart';
import '../core/app_colors.dart';
import 'AddAddressScreen.dart';

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
              image: "IMG/bag/emptyCart.png",
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
                title: const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: TitlesTextWidget(
                    label: "Check Out",
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      await cartProvider.clearCartFromFirestore(
                          context: context);
                      cartProvider.clearLocalCart();
                    },
                    icon: const Icon(
                      Icons.clear_all,
                      color: AppColors.blackColor,
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
                                        color: AppColors.goldenColor, width: 2),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Ionicons.location,
                                        color: AppColors.goldenColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      TitlesTextWidget(
                                        label:
                                            "Please Add Your Address Information",
                                        color: AppColors.goldenColor,
                                        fontSize: 12,
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.goldenColor,
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
                                child: const CartWidget(),
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
                              TitlesTextWidget(
                                label: "Order Details",
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                              const SizedBox(
                                height: 14,
                              ),

                              ///Subtotal
                              Row(
                                children: [
                                  const TitlesTextWidget(
                                    label: "Subtotal : ",
                                    fontSize: 15,
                                  ),
                                  const Spacer(),
                                  TitlesTextWidget(
                                    label:
                                        "${cartProvider.getTotal(productProvider: productProvider).toStringAsFixed(2)} AED",
                                    fontSize: 15,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),

                              ///Shipping Fee
                              Row(
                                children: [
                                  const TitlesTextWidget(
                                    label: "Shipping Fee : ",
                                    fontSize: 15,
                                  ),
                                  const Spacer(),
                                  TitlesTextWidget(
                                    label: " ${shippingFee.toString()} AED",
                                    fontSize: 15,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Divider(thickness: 1),
                              ///// Total
                              Row(
                                children: [
                                  const TitlesTextWidget(
                                    label: "Total : ",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const Spacer(),
                                  TitlesTextWidget(
                                    label: " ${Total.toStringAsFixed(2)} AED",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                    color: AppColors.goldenColor,
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

    return ListTile(
      leading: SizedBox(
        width: 20,
        // margin: const EdgeInsets.only(bottom: 40, left: 10),
        child: Radio<AddressModel>(
          fillColor:
              MaterialStateColor.resolveWith((states) => AppColors.goldenColor),
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
          child: const Text(
            "Edit",
            style: TextStyle(color: AppColors.goldenColor),
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
              const Icon(
                Icons.verified,
                color: AppColors.goldenColor,
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
