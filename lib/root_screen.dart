import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/screens/offers/offers_screen.dart';
import 'package:smart_shop/shared/app/photo_link.dart';
import 'screens/profile/model/user-model.dart';
import 'providers/address_provider.dart';
import 'screens/cart/provider/cart_provider.dart';
import 'providers/products_provider.dart';
import 'screens/profile/provider/user_provider.dart';
import 'providers/wishList_provider.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/search_screen.dart';
import 'shared/theme/app_colors.dart';

class RootScreen extends StatefulWidget {
  static const routeName = "/RootScreen";
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late List<Widget> screens;
  UserModel? userModel;
  bool isLoading = false;
  int currentScreen = 0;
  late PageController controller;
  bool isLoadingProd = true;
  late AppColors appColors;
  late CartProvider cartProvider;

  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        isLoading = true;
      });
      userModel = await userProvider.fetchUserInfo();
    } catch (error) {
      // ignore: use_build_context_synchronously
      print(error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    screens = const [
      HomePage(),
      SearchScreen(),
      OffersScreen(),
      CartScreen(),
      ProfileScreen(),
    ];
    controller = PageController(initialPage: currentScreen);
  }

  Future<void> fetchFCT() async {
    final productsProvider = Provider.of<ProductProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    final wishListProvider = Provider.of<WishListProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      Future.wait({
        productsProvider.fetchProducts(),
        productsProvider.fetchProductsHorizontal(),
        productsProvider.fetchProductsSecondHorizontal(),
        productsProvider.fetchProductsVertical(),
        userProvider.fetchUserInfo(),
      });
      Future.wait({
        cartProvider.fetchCart(),
      });
      Future.wait({
        addressProvider.fetchAddress(),
      });
      Future.wait({
        wishListProvider.fetchWishList(),
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (isLoadingProd) {
      fetchFCT();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final cartProvider = Provider.of<CartProvider>(context, listen: true);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentScreen,
        iconSize: 20,
        selectedItemColor:  appColors.primaryColor,
        unselectedItemColor: appColors.primaryColor,
        onTap: (index) {
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        items: [
          BottomNavigationBarItem(
            label: "Home",
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: SvgPicture.asset(PhotoLink.homeFilledLink ,color: appColors.primaryColor,),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: SvgPicture.asset(PhotoLink.homeLink,color: appColors.primaryColor,),
            ),
          ),
          BottomNavigationBarItem(
            label: "Search",
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Icon(IconlyBold.search,color: appColors.primaryColor,),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Icon(
                IconlyLight.search,
                color: appColors.primaryColor,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: "Offers",
            activeIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(PhotoLink.offersLink,color: Colors.deepPurple),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: SvgPicture.asset(PhotoLink.offersLink,color: appColors.primaryColor),
            ),
          ),
          BottomNavigationBarItem(
            label: "Cart",
            activeIcon:Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Badge(
                label: Text(
                  "${cartProvider.getCartItems.length}",
                  style: const TextStyle(color: Colors.white,fontSize: 12),
                ),
                backgroundColor: blueColor,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: SvgPicture.asset(PhotoLink.cartFilledLink,color: appColors.primaryColor),
                ),
              ),
            ),
            icon: Badge(
              label: Text(
                "${cartProvider.getCartItems.length}",
                style: const TextStyle(color: Colors.white,fontSize: 12),
              ),
              backgroundColor: blueColor,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: SvgPicture.asset(PhotoLink.cartLink,color: appColors.primaryColor,),
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: CircleAvatar(
                radius: 13,
                backgroundImage: NetworkImage(
                  userModel != null && userModel!.userImage != null &&  userModel!.userImage != ""
                      ? userModel!.userImage.toString()
                      : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                ),
              ),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.green,
                child: CircleAvatar(
                  radius: 13,

                  backgroundImage: NetworkImage(
                    userModel != null && userModel!.userImage != null &&  userModel!.userImage != ""
                        ? userModel!.userImage.toString()
                        : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
