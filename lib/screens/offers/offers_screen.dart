import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/models/product_model.dart';
import 'package:smart_shop/screens/offers/widgets/offer_banner.dart';
import 'package:smart_shop/screens/offers/widgets/offers_card.dart';
import 'package:smart_shop/shared/app/constants.dart';
import 'package:smart_shop/shared/theme/app_colors.dart';
import '../../providers/products_provider.dart';


class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  ProductModel? productModel;
  late Timer _timer;
  int _colorIndex = 0;
  Color _backgroundColor = Colors.green.shade100;
  final List<Color> _colors = [Colors.blue.shade200, Colors.green.shade200, Colors.yellow.shade200];

  @override
  void initState() {
    super.initState();
    _startColorSwitching();
  }

  void _startColorSwitching() {
    _timer = Timer.periodic( const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _colorIndex = (_colorIndex + 1) % _colors.length;
        _backgroundColor = _colors[_colorIndex];
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
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: _backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        toolbarHeight: 80,
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
              child: Container(color: Colors.transparent),
          ),
        ),
        title: OfferBanner(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             kGap100,
             kGap50,
             Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ...List.generate(
                    productProvider.productsproductsSecondHorizontal.length,
                        (index) => ChangeNotifierProvider.value(
                      value: productProvider.productsproductsSecondHorizontal[index],
                      child: OffersCard(offerBgColor: Colors.redAccent.shade700, isOffer: true),
                    ),
                  ),
                  ...List.generate(
                    productProvider.productsproductsHorizontal.length,
                        (index) => ChangeNotifierProvider.value(
                      value: productProvider.productsproductsHorizontal[index],
                      child: OffersCard(offerBgColor: Colors.blue.shade700, isOffer: true),
                    ),
                  ),
                  ...List.generate(
                    productProvider.productsproductsVertical.length,
                        (index) => ChangeNotifierProvider.value(
                      value: productProvider.productsproductsVertical[index],
                      child: OffersCard(offerBgColor: Colors.green.shade700, isOffer: true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
          backgroundColor: blueColor,
          child: const Icon(CupertinoIcons.stop_circle, color: Colors.white,),
          onPressed: () =>  _timer.cancel(),
      ),
    );
  }
}
