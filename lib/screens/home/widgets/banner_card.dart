import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../core/app_constans.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: AppConsts.bannerImages.length,
      options:  CarouselOptions(
        height: 80.0,
        autoPlay: true,
        enlargeCenterPage: true,
        pageSnapping: true,
        viewportFraction: 1.2,
        enableInfiniteScroll: true,
      ),
      disableGesture: true,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Image.asset(AppConsts.bannerImages[itemIndex],height: 200,),
    );
  }
}
