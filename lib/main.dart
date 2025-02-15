import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/root_screen.dart';
import 'package:smart_shop/screens/splash_screen.dart';
import 'package:smart_shop/sideScreens/order_screen.dart';
import 'package:smart_shop/sideScreens/product_datails_screen.dart';
import 'package:smart_shop/sideScreens/viewed_Recent_Screen.dart';
import 'package:smart_shop/sideScreens/wislist_screen.dart';

import 'AUTH/forot_password_screen.dart';
import 'AUTH/login.dart';
import 'AUTH/register.dart';
import 'providers/address_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/products_provider.dart';
import 'providers/rating_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'providers/viewed_product_provider.dart';
import 'providers/wishList_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/search_screen.dart';
import 'sideScreens/AddAddressScreen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.deepPurple.shade200),
  );
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: LottieBuilder.asset(
          "assets/Lottie/Loading.json",
        ),),);
  };
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //     .then((_) {
  //
  // });
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
            ProductDetailsScreen.routName: (context) =>
            const ProductDetailsScreen(),
            WishListScreen.routName: (context) => const WishListScreen(),
            ViewedRecentScreen.routName: (context) =>
            const ViewedRecentScreen(),
            RegisterScreen.routName: (context) => const RegisterScreen(),
            LoginScreen.routName: (context) => const LoginScreen(),
            OrdersScreenFree.routeName: (context) =>
            const OrdersScreenFree(),
            ForgotPasswordScreen.routeName: (context) =>
            const ForgotPasswordScreen(),
            SearchScreen.routName: (context) => const SearchScreen(),
            HomePage.routName: (context) => const HomePage(),
            AddressEditScreen.routName: (context) =>
            const AddressEditScreen(),
          },
        );
      }),
    );
  }
}