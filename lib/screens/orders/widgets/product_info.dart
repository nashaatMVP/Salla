import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import '../../../shared/app/constants.dart';
import '../../../shared/app/custom_text.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({
    super.key,
    required this.image,
    required this.name,
    required this.qty,
    required this.price,
    required this.date,
  });

  final String image , name , qty , price ;
  final Timestamp date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: FancyShimmerImage(
              imageUrl: image,
            ),
          ),
          kGap20,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kGap10,
              SizedBox(
                width: 240,
                child: TextWidgets.bodyText1(
                  name,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              kGap5,
              TextWidgets.bodyText1(
                "AED $price",
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
              kGap5,
              Row(
                children: [
                  TextWidgets.bodyText1(
                    "Qty : $qty",
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  kGap100,
                  TextWidgets.bodyText1(
                    "${date.toDate().day} / ${date.toDate().month} / ${date.toDate().year}",
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ],
              ),
              kGap10,
            ],
          ),

        ],
      ),
    );
  }
}
