import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../PROVIDERS/cart_provider.dart';
import '../models/cart_model.dart';
import '../shared/constants.dart';
import '../shared/custom_text.dart';
import '../shared/theme/app_colors.dart';

class QuentityBottomWidget extends StatelessWidget {
  const QuentityBottomWidget({
    super.key,
    required this.cartModel,
  });
  final CartModel cartModel;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Column(
      children: [
        kGap10,
        Container(
          height: 6,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: appColors.primaryColor,
          ),
        ),
        Expanded(
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 100,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    cartProvider.updateQty(
                      Qty: index + 1,
                      productId: cartModel.producttID,
                    );
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextWidgets.bodyText1( "${index + 1}"),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
