import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:salla/shared/app/constants.dart';
import 'package:salla/shared/app/custom_button.dart';
import 'package:salla/shared/app/custom_container.dart';
import 'package:salla/shared/app/custom_text_field.dart';
import 'package:uuid/uuid.dart';
import '../../../core/my_app_functions.dart';
import '../../../shared/app/custom_text.dart';
import '../../../shared/theme/app_colors.dart';

class RatingSheet extends StatefulWidget {
  const RatingSheet({
    super.key,
    required this.orderId,
    required this.productId,
  });
  final String orderId;
  final String productId;

  @override
  State<RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<RatingSheet> {
  double rate = 0.0;
  bool isLoading = false;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final FocusNode titleNode = FocusNode();
  final FocusNode descriptionNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: TextWidgets.bodyText1("Your FeedBack",fontSize: 20,fontWeight: FontWeight.bold)),
          kGap5,
          Center(
            child: RatingBar.builder(
              minRating: 0,
              itemCount: 5,
              initialRating: 0,
              allowHalfRating: true,
              direction: Axis.horizontal,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star_purple500_outlined,
                color: Colors.green.shade700,
              ),
              onRatingUpdate: (rating) =>  setState(() => rate = rating),
            ),
          ),
          kGap10,
          CustomFormField(
              controller: _title,
              focusNode: titleNode,
              hintName: "Title",
              iconData: Icons.reviews_outlined,
              onFieldSubmitted: (v) {},
              obscureText: false,
          ),
          CustomFormField(
            hintName: "Review",
            controller: _description,
            focusNode: descriptionNode,
            iconData: Icons.star_border_outlined,
            onFieldSubmitted: (v) {},
            obscureText: false,
          ),
          kGap10,
          GestureDetector(
            onTap: () async {
              if (_title.text != "" && _description != "" && rate != 0) {
                await rating();
                await displayProductMaxRating(widget.productId);
              } else {
                MyAppFunctions().globalMassage(context: context, message: "Please Fill Fields");
              }
            },
            child: CustomContainer(
              height: 40,
              color: Colors.green.shade700,
              radius: 12,
              child: Center(child: isLoading ? const CupertinoActivityIndicator() : TextWidgets.bodyText1("Submit",color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> rating() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;
    try {
      setState(() => isLoading = true);
      final ratingid = const Uuid().v4();
      print(ratingid);
      await FirebaseFirestore.instance
          .collection("ProductRating")
          .doc(ratingid)
          .set({
        "ratingid": ratingid,
        "userId": uid,
        "productId": widget.productId,
        "orderid": widget.orderId,
        "rating": rate,
        "titleReview": _title.text,
        "Review": _description.text,
      });
      await FirebaseFirestore.instance
          .collection("ordersAdvance")
          .doc(widget.orderId)
          .update({'orderStatus': "3"});
      MyAppFunctions().globalMassage(context: context, message: "Rating & Review Added");
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      setState(() => isLoading = false);
    } finally {
      setState(() => isLoading = false);

    }
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


