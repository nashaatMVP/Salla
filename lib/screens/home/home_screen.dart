import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/screens/home/widgets/banner_card.dart';
import 'package:smart_shop/screens/home/widgets/brands_card.dart';
import 'package:smart_shop/screens/home/widgets/category_widget.dart';
import 'package:smart_shop/screens/home/widgets/home_appbar.dart';
import 'package:smart_shop/screens/home/widgets/list_name.dart';
import 'package:smart_shop/screens/home/widgets/product_card.dart';
import 'package:smart_shop/shared/app/custom_container.dart';
import '../../core/app_constans.dart';
import '../../shared/app/constants.dart';
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
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
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
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: const HomeAppbar(),
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
              color: Colors.green.shade200,
              child: Column(
                children: [
                  kGap15,
                  const ListName(text: "Latest Arrivals"),
                  kGap15,
                  SizedBox(
                    height: 245,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: List.generate(
                            productsProvider
                                .productsproductsSecondHorizontal.length,
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
            kGap30,
            CustomContainer(
              height: 250,
              padding: const EdgeInsets.only(top: 15, left: 20),
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
            const BrandsCard(),
            kGap20,
            Center(
              child: Wrap(
                spacing: 5,
                runSpacing: 10,
                children: List.generate(
                  productsProvider.getproductsproductsVertical.length,
                      (index) => ChangeNotifierProvider.value(
                    value: productsProvider.getproductsproductsVertical[index],
                    child:  const ProductCard(offerBgColor: goldenColor),
                  ),
                ),
              ),
            ),
            kGap30,
          ],
        ),
      ),
    );
  }
}
