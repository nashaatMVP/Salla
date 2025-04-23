import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salla/shared/app/photo_link.dart';
import 'package:salla/shared/theme/app_colors.dart';
import 'custom_text.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  @override
  final Size preferredSize;
  final String text;
  final bool isCart;
  final bool isDelete;
  final void Function() onDelete;
  const CustomAppBar({
    Key? key,
    required this.onDelete,
    required this.text,
    this.isCart = false,
    this.isDelete = false,
  }): preferredSize = const Size.fromHeight(55), super(key: key);


  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return AppBar(
      elevation: 1,
      leadingWidth: 0,
      centerTitle: true,
      leading: const SizedBox.shrink(),
      scrolledUnderElevation: 4,
      toolbarHeight: preferredSize.height,
      backgroundColor: appColors.secondaryColor.withAlpha(450),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20,sigmaY : 20),
          child: Container(color: Colors.transparent),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isCart ? SvgPicture.asset(PhotoLink.cartLink,color: appColors.primaryColor,width: 30):
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
            ),
          ),
          TextWidgets.heading(text,color: appColors.primaryColor),
          isDelete
          ? IconButton(
            onPressed: onDelete,
            icon: Icon(
              CupertinoIcons.delete,
              color: appColors.primaryColor,
            ),
          )
          : const SizedBox.shrink()
        ],
      ),
    );
  }
}
