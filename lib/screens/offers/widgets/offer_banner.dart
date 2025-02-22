import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_shop/shared/app/custom_text.dart';

class OfferBanner extends StatefulWidget {
  @override
  _OfferBannerState createState() => _OfferBannerState();
}

class _OfferBannerState extends State<OfferBanner> {
  Color _bgColor = Colors.green.shade700;
  double _scale = 1.0;
  late Timer _timer;

  final List<Color> _colors = [
    Colors.green.shade700,
    Colors.blue.shade600,
    Colors.purple.shade600,
    Colors.orange.shade600,
  ];
  int _colorIndex = 0;

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
        _scale = 1.1;
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
          "Special Offers starting from  50%",
            fontSize: 17, color: Colors.white,
        ),
      ),
    );
  }
}
