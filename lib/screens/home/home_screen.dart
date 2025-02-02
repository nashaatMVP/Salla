import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/screens/home/widgets/banner_card.dart';
import 'package:smart_shop/screens/home/widgets/home_appbar.dart';
import 'package:smart_shop/screens/home/widgets/list_name.dart';
import 'package:smart_shop/shared/custom_container.dart';
import 'package:smart_shop/shared/custom_text.dart';
import 'package:smart_shop/widgets/category_widget.dart';
import 'package:smart_shop/widgets/itemWidgets/product_card.dart';
import '../../core/app_constans.dart';
import '../../models/user-model.dart';
import '../../providers/products_provider.dart';
import '../../providers/user_provider.dart';
import '../../shared/constants.dart';
import '../../shared/theme/app_colors.dart';
import '../search_screen.dart';

class HomePage extends StatefulWidget {
  static const routName = "/HomePage";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool isLoading = false;
  // Future<void> fetchUserInfo() async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     userModel = await userProvider.fetchUserInfo();
  //   } catch (error) {
  //     // ignore: use_build_context_synchronously
  //     print(error.toString());
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductProvider>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: HomeAppbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kGap200,
            kGap10,
            const BannerCard(),
            kGap35,
            const ListName(text: "Recommended For You"),
            kGap15,
            SizedBox(
              height: 245,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: List.generate(
                      productsProvider.getProductproductsHorizontal.length,
                      (index) => ChangeNotifierProvider.value(
                        value: productsProvider
                            .getProductproductsHorizontal[index],
                        child: ProductCard(
                            offerBgColor: Colors.deepPurple.shade400,
                            isOffer: false),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            kGap20,
            CustomContainer(
              height: 250,
              padding: const EdgeInsets.only(top: 15),
              color: CupertinoColors.systemGrey.withOpacity(0.1),
              child: GridView.builder(
                itemCount: AppConsts.categoryList.length,
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 17,
                  childAspectRatio: 1.7,
                ),
                itemBuilder: (context, index) {
                  return CategoryRoundedWidget(
                    image: AppConsts.categoryList[index].image,
                    name: AppConsts.categoryList[index].name,
                  );
                },
              ),
            ),
            kGap30,
            CustomContainer(
              color: Colors.green.shade200,
              child: Column(
                children: [
                  kGap15,
                  const ListName(text: "Latest Arrivals"),
                  kGap15,
                  SizedBox(
                    height: 245,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: List.generate(
                            productsProvider
                                .productsproductsSecondHorizontal.length,
                            (index) => ChangeNotifierProvider.value(
                              value: productsProvider
                                  .productsproductsSecondHorizontal[index],
                              child: ProductCard(
                                  offerBgColor: Colors.green.shade700),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  kGap10,
                ],
              ),
            ),
            kGap15,
            const ListName(text: "Best Sellers"),
            kGap15,
            // Visibility(
            //   visible: productsProvider.getproductsproductsVertical.isNotEmpty,
            //   child: SizedBox(
            //     height: 300,
            //     width: double.infinity,
            //     child: Padding(
            //       padding: const EdgeInsets.only(left: 8.0),
            //       child: ListView.builder(
            //         physics: const BouncingScrollPhysics(),
            //         scrollDirection: Axis.horizontal,
            //         itemCount:
            //             productsProvider.getproductsproductsVertical.length < 10
            //                 ? productsProvider
            //                     .getproductsproductsVertical.length
            //                 : 10,
            //         itemBuilder: (context, index) {
            //           return ChangeNotifierProvider.value(
            //             value:
            //                 productsProvider.getproductsproductsVertical[index],
            //             child: ProductCard(
            //                 offerBgColor: Colors.deepPurple.shade400),
            //           );
            //         },
            //       ),
            //     ),
            //   ),
            // ),

            // SizedBox(
            //   height: 220,
            //   child: GridView.builder(
            //       itemCount: productsProvider.getproductsproductsVertical.length,
            //       scrollDirection: Axis.vertical,
            //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 3,
            //         crossAxisSpacing: 0,
            //         mainAxisSpacing: 20,
            //         childAspectRatio: 1.1 / 1.8,
            //       ),
            //       itemBuilder: (context , index) => ChangeNotifierProvider.value(
            //         value:
            //         productsProvider.getproductsproductsVertical[index],
            //         child: ProductCard(
            //             offerBgColor: Colors.deepPurple.shade400),
            //       ),
            //   ),
            // ),


            kGap15,
          ],
        ),
      ),
    );
  }
}
