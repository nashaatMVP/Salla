import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_shop/shared/app/custom_text.dart';

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
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.orange,
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
      height: 50,
      transform: Matrix4.diagonal3Values(1, _scale, 1),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius:  BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(3, 4),
          ),
        ],
      ),
      child: Center(
        child: TextWidgets.subHeading(
           "Special Offers 50%",
            fontSize: 20, color: Colors.white,
        ),
      ),
    );
  }
}
