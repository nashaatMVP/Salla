import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salla/core/app_constans.dart';
import 'package:salla/shared/app/custom_text.dart';

class OfferBanner extends StatefulWidget {
  const OfferBanner({super.key});

  @override
  _OfferBannerState createState() => _OfferBannerState();
}

class _OfferBannerState extends State<OfferBanner> {
  Color _bgColor = Colors.green.shade700;
  double _scale = 1.0;
  late Timer _timer;
  int _colorIndex = 0;
  final List<Color> _colors = [
    Colors.black,
    Colors.black45,
    Colors.black45,
    Colors.black26,
  ];

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _colorIndex = (_colorIndex + 1) % _colors.length;
        _bgColor = _colors[_colorIndex];
        _scale = 1.3;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _scale = 1.0;
        });
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.bounceInOut,
      height: 30,
      transform: Matrix4.diagonal3Values(1, _scale , _scale),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius:  BorderRadius.circular(5),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 4),
          child: Row(
            children: List.generate(
              AppConsts.brandSvgs.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SvgPicture.asset(AppConsts.brandSvgs[index],width: 20,color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
