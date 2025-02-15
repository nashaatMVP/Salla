import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../core/my_app_functions.dart';
import '../providers/products_provider.dart';
import '../providers/user_provider.dart';
import '../screens/cart/provider/cart_provider.dart';
import '../shared/custom_text.dart';
import '../shared/theme/app_colors.dart';

class RatingScreen extends StatefulWidget {
  final String orderid;
  final String productid;

  const RatingScreen(this.orderid, this.productid, {super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double rate = 0.0;
  final TextEditingController _titlereviewController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    final appColors = Theme.of(context).extension<AppColors>()!;
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final productProvider =  Provider.of<ProductProvider>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.cancel,
              color: Colors.white,
            )),
        elevation: 0,
        backgroundColor: appColors.primaryColor,
        centerTitle: true,
        title: TextWidgets.bodyText1("Your FeedBack"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "How would you rate it?",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 15),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) =>  Icon(
                      Icons.star,
                      color:  appColors.primaryColor,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        rate = rating;
                      });
                      print(rate);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Title your review",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: TextFormField(
                  controller: _titlereviewController,
                  decoration: InputDecoration(
                      hintText: "What's most important to know?",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Write your review",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: TextFormField(
                  controller: _reviewController,
                  maxLines: 5,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.only(top: 10, left: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ///////////////////////////  BUTTON   ////////////////////////////////
              GestureDetector(
                onTap: () async {
                  if (_titlereviewController.text != "" &&
                      _reviewController != "" &&
                      rate != 0) {
                    await rating();
                    await displayProductMaxRating(widget.productid);
                  } else {
                    MyAppFunctions().globalMassage(
                        context: context, message: "Please Fill Fields");
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 60,
                      width: 330,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: appColors.primaryColor,
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> displayProductMaxRating(String productId) async {
    double productMaxRating = await calculateProductAverageRating(productId);
    await FirebaseFirestore.instance
        .collection("products")
        .doc(productId)
        .update({
      'TotalproductRating': productMaxRating,
    });
    print('Max rating for product $productId: $productMaxRating');
    // Use the retrieved max rating as needed in your app UI
  }

  Future<void> rating() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;
    print(uid);
    try {
      // setState(() {
      //   isLoading = true;
      // });

      final ratingid = const Uuid().v4();
      print(ratingid);
      await FirebaseFirestore.instance
          .collection("ProductRating")
          .doc(ratingid)
          .set({
        "ratingid": ratingid,
        "userId": uid,
        "productId": widget.productid,
        "orderid": widget.orderid,
        "rating": rate,
        "titleReview": _titlereviewController.text,
        "Review": _reviewController.text
      });
      await FirebaseFirestore.instance
          .collection("ordersAdvance")
          .doc(widget.orderid)
          .update({'orderStatus': "3"});
      // ignore: use_build_context_synchronously
      MyAppFunctions()
          .globalMassage(context: context, message: "Rating & Review Added");
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      print(e.toString());
    } finally {}
  }

  Future<double> calculateProductAverageRating(String productId) async {
    double totalRating = 0;
    int numberOfRatings = 0;

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('ProductRating')
          .where('productId', isEqualTo: productId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          double rating = doc['rating'] as double;
          totalRating += rating;
          numberOfRatings++;
        }
      }
    } catch (e) {
      print("Error fetching ratings: $e");
    }

    if (numberOfRatings > 0) {
      double averageRating = totalRating / numberOfRatings;
      return averageRating;
    } else {
      return 0; // Return 0 if there are no ratings for the product
    }
  }
}
