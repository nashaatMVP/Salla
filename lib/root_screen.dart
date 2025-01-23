import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/PROVIDERS/address_provider.dart';
import 'package:smart_shop/PROVIDERS/cart_provider.dart';
import 'package:smart_shop/PROVIDERS/products_provider.dart';
import 'package:smart_shop/PROVIDERS/theme_provider.dart';
import 'package:smart_shop/PROVIDERS/user_provider.dart';
import 'package:smart_shop/PROVIDERS/wishList_provider.dart';
import 'package:smart_shop/SCREENS/cart_screen.dart';
import 'SCREENS/home_screen.dart';
import 'SCREENS/profile_screen.dart';
import 'SCREENS/search_screen.dart';
import 'core/app_colors.dart';

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
      print(e.toString());
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
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentScreen,
        selectedItemColor: AppColors.goldenColor,
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
              color: themeProvider.getIsDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          BottomNavigationBarItem(
            label: "Search",
            activeIcon: const Icon(IconlyBold.search),
            icon: Icon(
              IconlyLight.search,
              color: themeProvider.getIsDarkTheme ? Colors.white : Colors.black,
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
              backgroundColor: AppColors.goldenColor,
              child: Icon(
                IconlyLight.bag,
                color:
                    themeProvider.getIsDarkTheme ? Colors.white : Colors.black,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            activeIcon: const Icon(IconlyBold.profile),
            icon: Icon(
              IconlyLight.profile,
              color: themeProvider.getIsDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
