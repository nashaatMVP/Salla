import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../core/app_constans.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CarouselSlider.builder(
        disableGesture: true,
        itemCount: AppConsts.bannerImages.length,
        options:  CarouselOptions(
          height: 70.0,
          autoPlay: true,
          enlargeCenterPage: true,
          pageSnapping: false,
          viewportFraction: 1,
          enableInfiniteScroll: false,
          autoPlayInterval : const Duration(seconds: 4),
          autoPlayAnimationDuration : const Duration(milliseconds: 400),
          autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
        ),
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Image.asset(AppConsts.bannerImages[itemIndex],height: 200,),
      ),
    );
  }
}
