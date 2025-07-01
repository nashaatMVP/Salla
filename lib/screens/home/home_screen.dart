import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salla/screens/home/widgets/banner_card.dart';
import 'package:salla/screens/home/widgets/brands_card.dart';
import 'package:salla/screens/home/widgets/category_widget.dart';
import 'package:salla/screens/home/widgets/home_appbar.dart';
import 'package:salla/screens/home/widgets/list_name.dart';
import 'package:salla/screens/home/widgets/product_card.dart';
import 'package:salla/shared/app/custom_container.dart';
import '../../core/app_constans.dart';
import '../../shared/app/constants.dart';
import '../category/category_items.dart';
import '../profile/model/user-model.dart';
import '../../providers/products_provider.dart';
import '../../shared/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  static const routName = "/HomePage";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? userModel;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double productHeight = 280;
    final appColors = Theme.of(context).extension<AppColors>()!;
    final productsProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: const HomeAppbar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kGap210,
            const BannerCard(),
            kGap35,
            CarouselSlider.builder(
              itemCount: AppConsts.categoryList.length,
              options:  CarouselOptions(
                height: 100.0,
                autoPlay: true,
                enlargeCenterPage: false,
                pageSnapping: true,
                viewportFraction: 0.2,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration : const Duration(seconds: 1),
                autoPlayCurve: Curves.easeIn,
              ),
              disableGesture: true,
              itemBuilder: (BuildContext context, int index, int pageViewIndex) {
                return CategoryRoundedWidget(
                  image: AppConsts.categoryList[index].image,
                  name: AppConsts.categoryList[index].name,
                );
              },
            ),
            kGap30,
            const ListName(text: "Recommended For You"),
            kGap15,
            SizedBox(
              height: productHeight,
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: List.generate(
                      productsProvider.getProductproductsHorizontal.length,
                      (index) => ChangeNotifierProvider.value(
                        value: productsProvider.getProductproductsHorizontal[index],
                        child: ProductCard(
                          isOffer: false,
                          offerBgColor: Colors.deepPurple.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            kGap20,
            CustomContainer(
              color: Colors.green.shade100,
              child: Column(
                children: [
                  kGap15,
                  const ListName(text: "Latest Arrivals"),
                  kGap15,
                  SizedBox(
                    height: productHeight,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: List.generate(
                            productsProvider.productsproductsSecondHorizontal.length,
                            (index) => ChangeNotifierProvider.value(
                              value: productsProvider.productsproductsSecondHorizontal[index],
                              child: ProductCard(offerBgColor: Colors.green.shade700),
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
            kGap40,
            Container(
              color: blueColor.withAlpha(450),
              child: Column(
                children: [
                  const BrandsCard(),
                  kGap5,
                  GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    physics: const NeverScrollableScrollPhysics(),
                      itemCount: productsProvider.getproductsproductsVertical.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 0,
                          childAspectRatio: 0.71,
                      ),
                      itemBuilder: (context , index) => ChangeNotifierProvider.value(
                        value: productsProvider.getproductsproductsVertical[index],
                        child: ProductCard(
                          width: 200,
                          offerBgColor: Colors.red.shade400,
                        ),
                      ),
                  ),
                ],
              ),
            ),
            kGap30,
          ],
        ),
      ),
    );
  }
}
