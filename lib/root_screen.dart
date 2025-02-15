import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'providers/address_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/products_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'providers/wishList_provider.dart';
import 'screens/cart_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile_screen.dart';
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
  int currentScreen = 0;
  late PageController controller;
  bool isLoadingProd = true;

  @override
  void initState() {
    super.initState();
    screens = const [
      HomePage(),
      SearchScreen(),
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
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),


      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentScreen,
        selectedItemColor: appColors.primaryColor,
        onTap: (index) {
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        items: [

          BottomNavigationBarItem(
            label: "Home",
            activeIcon: const Icon(IconlyBold.home),
            icon: Icon(
              IconlyLight.home,
              color: appColors.primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            label: "Search",
            activeIcon: const Icon(IconlyBold.search),
            icon: Icon(
              IconlyLight.search,
              color: appColors.primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            label: "Cart",
            activeIcon: const Icon(IconlyBold.bag),
            icon: Badge(
              label: Text(
                "${cartProvider.getCartItems.length}",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: appColors.primaryColor,
              child: Icon(
                IconlyLight.bag,
                color:
                appColors.primaryColor,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            activeIcon: const Icon(IconlyBold.profile),
            icon: Icon(
              IconlyLight.profile,
              color: appColors.primaryColor,
            ),
          ),

        ],
      ),
    );
  }
}
