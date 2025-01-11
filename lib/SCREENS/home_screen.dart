import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/MODELS/user-model.dart';
import 'package:smart_shop/PROVIDERS/products_provider.dart';
import 'package:smart_shop/PROVIDERS/theme_provider.dart';
import 'package:smart_shop/PROVIDERS/user_provider.dart';
import 'package:smart_shop/SCREENS/search_screen.dart';
import 'package:smart_shop/WIDGETS/ITEM%20WIDGETS/Last_Grid_widget.dart';
import 'package:smart_shop/WIDGETS/ITEM%20WIDGETS/Latest_Arrival.dart';
import 'package:smart_shop/WIDGETS/category_widget.dart';

import '../core/app_constans.dart';

class HomePage extends StatefulWidget {
  static const routName = "/HomePage";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
////////////////////////////////// New User /////////////////////////////////////////////////////////////////
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

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      //////////////////////////////////////   B O D Y   /////////////////////////////////////////////////
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade200,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  ////////////////////////////////////  User Info  //////////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, top: 0, right: 10, bottom: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width * 0.04,
                        ),

                        Visibility(
                          visible: user == null,
                          child: Text(
                            "SALLA",
                            maxLines: 1,
                            style: GoogleFonts.aldrich(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: user != null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "SALLA",
                                maxLines: 1,
                                style: GoogleFonts.aldrich(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: size.width * 0.7,
                                child: Text(
                                  user == null
                                      ? ""
                                      : "Hello, ${userModel!.userName.toString()}",
                                  maxLines: 1,
                                  style: GoogleFonts.aldrich(
                                      fontSize: user == null ? 25 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),

                        ////////   Image   /////////
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).hoverColor,
                            image: DecorationImage(
                              image: NetworkImage(
                                userModel != null &&
                                        userModel!.userImage != null &&
                                        userModel!.userImage != ""
                                    ? userModel!.userImage.toString()
                                    : "https://media.raritysniper.com/hape-prime/4280-600.webp?cacheId=2",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  ///////////////////////////////////////  Search text-field /////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    child: Row(
                      children: [
                        Container(
                            height: 42,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromARGB(255, 255, 249, 249),
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 43,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: TextField(
                              readOnly: true,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, SearchScreen.routName);
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8),
                                hintText: "Search.....",
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                  color: themeProvider.getIsDarkTheme
                                      ? Colors.black
                                      : Colors.black,
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 255, 249, 249),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade100),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ///CATEGORIES
            SizedBox(
              height: size.height * 0.01,
            ),
            SizedBox(
              height: size.height * 0.17,
              width: double.infinity,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: AppConsts.categoryList.length,
                  itemBuilder: (context, index) {
                    return CategoryRoundedWidget(
                      image: AppConsts.categoryList[index].image,
                      name: AppConsts.categoryList[index].name,
                    );
                  }),
            ),
            /// Swiper
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SizedBox(
                height: 200,
                child: Swiper(
                  itemCount: 2,
                  itemBuilder: (context,index) => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration:  BoxDecoration(
                      image: DecorationImage(image: AssetImage(AppConsts.bannerImg),fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                ),
                ),
              ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15),
            //   child: SizedBox(
            //     height: size.height * 0.3,
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(20),
            //       child: Swiper(
            //         itemBuilder: (BuildContext context, int index) {
            //           return Image.network(
            //             AppConsts.bannerImages[index],
            //             fit: BoxFit.fill,
            //           );
            //         },
            //         itemCount: AppConsts.bannerImages.length,
            //         autoplay: false,
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),
            /// Recommended For You

            const CustomizeListName(
              text: "Recommended For You",
            ),

            SizedBox(
              height: size.height * 0.04,
            ),

            Visibility( visible: productsProvider.getProductproductsHorizontal.isNotEmpty,
              child: SizedBox(
                height: size.height * 0.40,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: productsProvider
                                  .getProductproductsHorizontal.length <
                              10
                          ? productsProvider
                              .getProductproductsHorizontal.length
                          : 10,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: productsProvider
                                .getProductproductsHorizontal[index],
                            child: const LatestArrivalProductWidget());
                      }),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),

            ///Latest Arrival
            const SizedBox(
              height: 5,
            ),
            Visibility(
              visible:
                  productsProvider.getProductproductsHorizontal.isNotEmpty,
              child: const CustomizeListName(text: "Latest Arrivals"),
            ),

            const SizedBox(
              height: 15,
            ),

            Visibility(
              visible: productsProvider
                  .productsproductsSecondHorizontal.isNotEmpty,
              child: SizedBox(
                height: size.height * 0.45,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: productsProvider
                                .productsproductsSecondHorizontal.length <
                            10
                        ? productsProvider
                            .productsproductsSecondHorizontal.length
                        : 10,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: productsProvider
                            .productsproductsSecondHorizontal[index],
                        child: const LatestArrivalProductWidget(),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            ///Recommended For You
            Visibility(
              visible: productsProvider.getproductsproductsVertical.isNotEmpty,
              child: Container(
                color: const Color(0xffCBB26A),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///// List Name
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: CustomizeListName(text: "Best Sellers"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //// Grid view
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          childAspectRatio: 2 / 3.3,
                        ),
                        itemCount: productsProvider
                                    .getproductsproductsVertical.length <
                                10
                            ? productsProvider
                                .getproductsproductsVertical.length
                            : 10,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                            value: productsProvider
                                .getproductsproductsVertical[index],
                            child: const LastGridWidget(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////  Customize List Name  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

class CustomizeListName extends StatelessWidget {
  const CustomizeListName({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
        ),
        child: Text(
          text,
          style: GoogleFonts.aldrich(fontSize: 18),
        ));
  }
}
