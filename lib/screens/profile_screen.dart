import 'package:country_flags/country_flags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/AUTH/login.dart';
import 'package:smart_shop/AUTH/register.dart';
import 'package:smart_shop/MODELS/user-model.dart';
import 'package:smart_shop/PROVIDERS/theme_provider.dart';
import 'package:smart_shop/PROVIDERS/user_provider.dart';
import 'package:smart_shop/core/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../WIDGETS/circular_widget.dart';
import '../core/app_colors.dart';
import '../core/text_widget.dart';
import '../sideScreens/AddAddressScreen.dart';
import '../sideScreens/order_screen.dart';
import '../sideScreens/wislist_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool isVisible = false;
  @override
  bool get wantKeepAlive => true;
  XFile? _pickedImage;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool isLoading = false;

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
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: LoadingManager(
          isLoading: isLoading,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Visibility(
                  visible: user == null ? true : false,
                  child: Column(
                    children: [
                      kGap20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //// Login
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeProvider.getIsDarkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  elevation: 10,
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const RegisterScreen()))),
                                child: Text(
                                  "Register",
                                  style: GoogleFonts.aldrich(
                                    color: themeProvider.getIsDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Text(
                            "or",
                            style: GoogleFonts.alike(color: Colors.white),
                          ),

                          //// Login
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeProvider.getIsDarkTheme
                                      ? Colors.black
                                      : Colors.white,
                                  elevation: 10,
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const LoginScreen()))),
                                child: Text(
                                  "LOGIN",
                                  style: GoogleFonts.aldrich(
                                      color: themeProvider.getIsDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                user == null
                    ? const SizedBox.shrink()
                    : Container(
                        padding: const EdgeInsets.only(bottom: 15, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade200,
                        ),
                        child: Column(
                          children: [
                            kGap25,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).hoverColor,
                                      border: Border.all(
                                        color: const Color.fromARGB(255, 134, 58, 141),
                                        width: 3,
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          userModel != null &&
                                                  userModel!.userImage !=
                                                      null &&
                                                  userModel!.userImage != ""
                                              ? userModel!.userImage.toString()
                                              : "https://media.raritysniper.com/hape-prime/4280-600.webp?cacheId=2",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  kGap10,
                                  Column(
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: size.width * 0.7,
                                          child: TitlesTextWidget(
                                            label: userModel != null
                                                ? userModel!.userName.toString()
                                                : "userId234948883",
                                            fontWeight: FontWeight.w600,
                                          ),),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TitlesTextWidget(
                                            label: userModel != null
                                                ? userModel!.userEmail.toString()
                                                : "nashaat@gmail.com",
                                            fontSize: 17,

                                          ),
                                          kGap5,
                                          const Icon(
                                            Icons.verified,
                                            size: 14,
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                Container(
                  decoration: BoxDecoration(
                    color: themeProvider.getIsDarkTheme
                        ? Colors.black
                        : Colors.white,
                    border: Border.fromBorderSide(BorderSide(
                      color: themeProvider.getIsDarkTheme
                          ? Colors.black
                          : Colors.white,
                    )),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 2,
                      ),
                      Visibility(
                        visible: user == null ? false : true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /////  ORDERS  ///////
                            CustomRow(
                                text: "Orders",
                                icon: const Icon(
                                  Icons.delivery_dining_sharp,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    OrdersScreenFree.routeName,
                                  );
                                }),
                            /////  Wishlist  ///////
                            CustomRow(
                                text: "Wishlist",
                                icon: const Icon(
                                  IconlyBold.heart,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    WishListScreen.routName,
                                  );
                                }),
                            /////  Address  ///////
                            CustomRow(
                                text: "Address",
                                icon: const Icon(
                                  Icons.map_outlined,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AddressEditScreen.routName,
                                  );
                                }),
                          ],
                        ),
                      ),

                      CustomColumn(
                        text: "Settings",
                        widget: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 20,
                        ),
                        color: AppColors.blackColor,
                        icon: Icons.keyboard_double_arrow_down_outlined,
                        onTap: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                      ),

                      Visibility(
                        visible: isVisible,
                        child: Column(
                          children: [
                            //////// mode
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SwitchListTile(
                                  activeColor:
                                      const Color.fromARGB(255, 84, 226, 84),
                                  title: Text(
                                    themeProvider.getIsDarkTheme
                                        ? "Dark Mode"
                                        : "Light Mode",
                                    style: GoogleFonts.aldrich(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                  secondary: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                    child: const Icon(
                                      Ionicons.invert_mode,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      size: 20,
                                    ),
                                  ),
                                  value: themeProvider.getIsDarkTheme,
                                  onChanged: (value) {
                                    themeProvider.setDarkTheme(
                                        themeValue: value);
                                  }),
                            ),
                            /////// flag
                            CustomColumn(
                              text: "United Arab Emarites",
                              widget: CountryFlag.fromCountryCode(
                                "ae",
                                height: 20,
                                width: 20,
                              ),
                              onTap: () {},
                            ),

                            CustomColumn(
                              text: "ENGLISH",
                              widget: const Icon(
                                Icons.language,
                                color: Colors.white,
                                size: 20,
                              ),
                              onTap: () {},
                            ),
                            //////  Delete ACC
                            Visibility(
                              visible: user == null ? false : true,
                              child: CustomColumn(
                                text: "Delete Account",
                                widget: const Icon(
                                  Icons.person_add_disabled_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onTap: () {
                                  userProvider.deleteUserInfo();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      CustomColumn(
                        text: "Help",
                        widget: const Icon(
                          Icons.help_outline_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        onTap: () {},
                      ),
                      CustomColumn(
                        text: "Contact us",
                        widget: const Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 20,
                        ),
                        onTap: () async {
                          final Uri url =
                              Uri(scheme: "tel", path: "+971 505344683");
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            print("Cannot connect to phone number");
                          }
                        },
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (user == null) {
                            Navigator.pushNamed(
                              context,
                              LoginScreen.routName,
                            );
                          } else {
                            await FirebaseAuth.instance.signOut();
                            if (!mounted) return;
                            Navigator.pushNamed(
                              context,
                              LoginScreen.routName,
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.blackColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.power_settings_new_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                user == null ? "Sign in" : "Sign Out",
                                style: GoogleFonts.aldrich(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Center(
                            child: SizedBox(
                              width: 140,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Ionicons.logo_instagram,
                                    color: Color(0xffC13584),
                                  ),
                                  Icon(
                                    Ionicons.logo_facebook,
                                    color: Color(0xff4267B2),
                                  ),
                                  Icon(
                                    Ionicons.logo_twitter,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ////////////////////////////////////// Terms  ///////////////////////////////////////////////
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SubtitleTextWidget(
                                label: "Terms of us",
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SubtitleTextWidget(
                                label: "Terms of sale",
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SubtitleTextWidget(
                                label: "Privacy Policy",
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.copyright,
                                size: 12,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: TitlesTextWidget(
                                  label: " 2023 salla.com All rights reversed.",
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  CustomRow({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });
  final String text;
  final Widget icon;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.blackColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              icon,
              const SizedBox(
                height: 10,
              ),
              Text(text,
                  style:GoogleFonts.alike(color: Colors.white, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomColumn extends StatelessWidget {
  CustomColumn({
    super.key,
    required this.text,
    required this.widget,
    required this.onTap,
    this.icon,
    this.color = Colors.black,
  });
  final String text;
  final Widget widget;
  final Color color;
  final IconData? icon;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(17),
              ),
              child: widget,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(text, style: GoogleFonts.alike(fontWeight: FontWeight.bold)),
            const Spacer(),
            Icon(
              icon,
              color: AppColors.goldenColor,
            ),
          ],
        ),
      ),
    );
  }
}
