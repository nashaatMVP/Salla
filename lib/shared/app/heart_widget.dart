import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:salla/providers/wishList_provider.dart';

class HeartButton extends StatefulWidget {

  const HeartButton({
    super.key,
    required this.productID,
    this.size,
    this.colorDisable = Colors.black,
    this.enabledColor = const Color.fromARGB(255, 189, 10, 10),
  });

  final String productID;
  final double? size;
  final Color? colorDisable;
  final Color? enabledColor;

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {
  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);
    return InkWell(
      onTap: () async {
        // wishListProvider.addOrRemoveFromWishList(productId: widget.productID);
        if (wishListProvider.getWishListItems.containsKey(widget.productID)) {
          await wishListProvider.removeWishListItemFromFirestor(
            context: context,
            wishListId:
                wishListProvider.getWishListItems[widget.productID]!.wishListID,
            productId: widget.productID,
          );
        } else {
          wishListProvider.addToWishListFirebase(
            productId: widget.productID,
            context: context,
          );
        }
        await wishListProvider.fetchWishList();
      },
      child: Icon(
        wishListProvider.isProdInWishList(productId: widget.productID)
            ? IconlyBold.heart
            : IconlyLight.heart,
        size: widget.size,
        color: wishListProvider.isProdInWishList(productId: widget.productID)
            ? widget.enabledColor
            : widget.colorDisable,
      ),
    );
  }
}
