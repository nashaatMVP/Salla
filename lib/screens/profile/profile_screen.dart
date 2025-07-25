import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:salla/screens/profile/widgets/guest_widget.dart';
import 'package:salla/screens/profile/widgets/profile_item.dart';
import 'package:salla/screens/profile/widgets/social_media_card.dart';
import 'package:salla/shared/app/custom_container.dart';
import 'package:salla/shared/app/photo_link.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/app/constants.dart';
import '../addreses/saved_address_screen.dart';
import '../auth/login.dart';
import 'model/user-model.dart';
import '../../providers/theme_provider.dart';
import 'provider/user_provider.dart';
import '../../shared/app/custom_text.dart';
import '../../shared/theme/app_colors.dart';
import '../orders/order_screen.dart';
import '../../shared/app/circular_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  XFile? _pickedImage;
  UserModel? userModel;
  bool isLoading = false;
  bool isVisible = false;
  @override
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: appColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: appColors.secondaryColor.withAlpha(450),
        scrolledUnderElevation: 4,
        elevation: 2,
        toolbarHeight: 100,
        centerTitle: false,
        leadingWidth: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20,sigmaY : 20),
            child: Container(color: Colors.transparent),
          ),
        ),
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
               showDialog(
                  barrierDismissible: true,
                   context: context,
                   builder: (context) => Padding(
                     padding: const EdgeInsets.all(20.0),
                     child: CircleAvatar(
                       radius: 70,
                       backgroundImage: NetworkImage(
                         userModel != null &&
                             userModel!.userImage !=
                                 null &&
                             userModel!.userImage != ""
                             ? userModel!.userImage.toString()
                             : PhotoLink.defaultImg,
                       ),
                     ),
                   ),
               );
               },
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.green.shade500,
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    userModel != null &&
                        userModel!.userImage !=
                            null &&
                        userModel!.userImage != ""
                        ? userModel!.userImage.toString()
                        : PhotoLink.defaultImg,
                  ),
                ),
              ),
            ),
            kGap10,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgets.heading(userModel != null
                    ? userModel!.userName.toString()
                    : "Rich Sonic",
                  color: appColors.primaryColor,
                ),
                TextWidgets.subHeading(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  userModel != null ? userModel!.userEmail.toString() : "RichSonic@gmail.com",
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),

      body: LoadingManager(
        isLoading: isLoading,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              kGap100,
              kGap75,

              user == null ? const GuestWidget() : CustomContainer(
                radius: 12,
                child: Column(
                  children: [
                    ProfileItem(
                      text: "Address",
                      svg: PhotoLink.addressLink,
                      function: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (c) => const SavedAddressScreen(),
                        ),
                      ),
                    ),
                    ProfileItem(
                      text: "Orders",
                      svg: PhotoLink.ordersLink,
                      function: () => Navigator.pushNamed(
                        context,
                        OrdersScreenFree.routeName,
                      ),
                    ),
                    ProfileItem(
                      text: "Contact us+",
                      svg: PhotoLink.supportLink,
                      function: () async {
                        final Uri url = Uri(scheme: "tel", path: "+971 505344683");
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          print("Cannot connect to phone number");
                        }
                      },
                    ),
                    ProfileItem(
                      text: "Theme",
                      svg: PhotoLink.themeLink,
                      function: () => context.read<ThemeProvider>().toggleTheme(),
                    ),
                    ProfileItem(
                      text: "Sign Out",
                      svg: PhotoLink.signOutLink,
                      function: () async {
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
                    ),
                    ProfileItem(
                      text: "Delete Account",
                      svg: PhotoLink.deleteUserLink,
                      function: () => userProvider.deleteUserInfo(),
                    ),
                  ],
                ),
              ),

              kGap30,
              const SocialMediaCard(),
            ],
          ),
        ),
      ),
    );
  }
}


