// custom_app_bar.dart
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../SCREENS/search_screen.dart';
import '../../../core/app_constans.dart';
import '../../../providers/theme_provider.dart';
import '../../../shared/constants.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/theme/app_colors.dart';
import 'home_categories.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  HomeAppbar({Key? key}): preferredSize = const Size.fromHeight(130), super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return AppBar(
      backgroundColor: Colors.white.withAlpha(300),
      scrolledUnderElevation: 0,
      toolbarHeight: 130,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20,sigmaY : 20),
          child: Container(color: Colors.transparent,),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidgets.heading("Salla",color: appColors.primaryColor,fontSize: 17),
                 GestureDetector(
                    onTap: () => context.read<ThemeProvider>().toggleTheme(),
                     child: Icon(Icons.light_mode_outlined,color: appColors.primaryColor)),
              ],
            ),
          ),
          kGap10,
          CupertinoTextField(
            readOnly: true,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SearchScreen())),
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 9),
            placeholder: "Phones, Games , Airpods and More",
            placeholderStyle: TextStyle(
              fontSize: 13,
              color: appColors.primaryColor,
            ),
            decoration: BoxDecoration(
              color: appColors.searchColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: appColors.primaryColor.withAlpha(50),
              ),
            ),
            focusNode: FocusNode(),
          ),
          kGap15,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            child: Row(
              children: List.generate(
                  AppConsts.categoryList.length,
                  (index) =>  HomeCategories(text: AppConsts.categoryList[index].name),
              ),
            ),
          ),
          kGap10,
      ],
    ),
    );
  }
}
