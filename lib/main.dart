import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:salla/root_screen.dart';
import 'package:salla/screens/auth/forot_password_screen.dart';
import 'package:salla/screens/auth/login.dart';
import 'package:salla/screens/auth/register.dart';
import 'package:salla/screens/category/category_items.dart';
import 'package:salla/screens/product/product_datails_screen.dart';
import 'package:salla/screens/orders/order_screen.dart';
import 'package:salla/screens/sideScreens/viewed_Recent_Screen.dart';
import 'package:salla/screens/sideScreens/wislist_screen.dart';
import 'screens/addreses/provider/address_provider.dart';
import 'screens/cart/provider/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/products_provider.dart';
import 'providers/rating_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/profile/provider/user_provider.dart';
import 'providers/viewed_product_provider.dart';
import 'providers/wishList_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/search/search_screen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.deepPurple.shade200),
  );
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: CupertinoActivityIndicator(),
      ),
    );
  };
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ThemeProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return ProductProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return CartProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return WishListProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return ViewedProductProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return UserProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return OrderProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return AddressProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return RatingProvider();
          },
        ),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: 'SALLA',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          home: const RootScreen(),
          routes: {
            RootScreen.routeName: (context) => const RootScreen(),
            ProductDetailsScreen.routName: (context) => const ProductDetailsScreen(),
            WishListScreen.routName: (context) => const WishListScreen(),
            ViewedRecentScreen.routName: (context) => const ViewedRecentScreen(),
            RegisterScreen.routName: (context) => const RegisterScreen(),
            LoginScreen.routName: (context) => const LoginScreen(),
            OrdersScreenFree.routeName: (context) => const OrdersScreenFree(),
            ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
            SearchScreen.routName: (context) => const SearchScreen(),
            CategoryItems.routName: (context) => const CategoryItems(),
            HomePage.routName: (context) => const HomePage(),
          },
        );
      }),
    );
  }
}