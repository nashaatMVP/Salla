import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../models/cart_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../shared/custom_text.dart';
import '../../shared/theme/app_colors.dart';
import '../qty_widget.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    color: final appColors = Theme.of(context).extension<AppColors>()!;

    final cartModel = Provider.of<CartModel>(context);
    final productsProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productsProvider.findById(cartModel.producttID);
    final cartProvider = Provider.of<CartProvider>(context);
    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Slidable(
                endActionPane:
                    ActionPane(motion: const ScrollMotion(), children: [
                  SlidableAction(
                    // An action can be bigger than the others.
                    flex: 2,
                    onPressed: (v) async {
                      await cartProvider.removeCartItemFromFirestor(
                        context: context,
                        cartId: cartModel.cartID,
                        productId: cartModel.producttID,
                        qty: cartModel.cartQty,
                      );
                      cartProvider.removeOneItem(
                        productId: getCurrentProduct.productID,
                      );
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ]),
                child: Material(
                  elevation: 20,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///
                          Column(
                            children: [
                              ////////////////////////////  IMAGE   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: FancyShimmerImage(
                                  imageUrl: getCurrentProduct.productImage,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),

                          const SizedBox(
                            width: 10,
                          ),
                          ////////////////////////////// TITLE PRICE STOCK //////////////////////////////////

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .55,
                                child:  TextWidgets.bodyText1(
                                 getCurrentProduct.productTitle,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ////////////////////////////////PRICE/////////////////////////////////////////
                              Row(
                                children: [
                                  TextWidgets.bodyText1(
                                   "AED",
                                  ),
                                  TextWidgets.bodyText1(
                                   " ${getCurrentProduct.productPrice}",
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              ////////////////////////////Only on Stock
                              TextWidgets.bodyText1(
                                    "Only ${getCurrentProduct.productQty} In Stock",
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              ////////////////////////////  QTY   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                              SizedBox(
                                height: 25,
                                width: 90,
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    await showModalBottomSheet(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              topLeft: Radius.circular(30)),
                                        ),
                                        context: context,
                                        builder: (context) {
                                          return QuentityBottomWidget(
                                            cartModel: cartModel,
                                          );
                                        });
                                  },
                                  icon: const Icon(
                                    IconlyLight.arrowDown2,
                                    // color: Colors.black,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    // getCurrentProduct.productQty
                                    "${cartModel.cartQty}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side:  BorderSide(
                                      width: 1,
                                      color: appColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
