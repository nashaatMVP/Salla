import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:salla/screens/orders/widgets/order_time_line.dart';
import 'package:salla/screens/orders/widgets/product_info.dart';
import 'package:salla/screens/orders/widgets/rating_sheet.dart';
import 'package:salla/shared/app/constants.dart';
import 'package:timelines_plus/timelines_plus.dart';
import '../../models/order_model.dart';
import '../../shared/app/custom_text.dart';
import '../../shared/theme/app_colors.dart';
import 'RatingScreen.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({super.key, required this.orderModelAdvanced});
  final OrderModelAdvanced orderModelAdvanced;

  @override
  Widget build(BuildContext context) {
    final order = orderModelAdvanced;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// product details
            ProductInfo(
                image: order.ImageUrl,
                name: order.prductTitle,
                qty: order.quntity,
                price: order.price,
                date: order.orderDate,
            ),
            kGap5,
            /// TimeLine
            OrderTimeLine(
                order : order.orderStatus.toString(),
                deliveryDate: order.deliverydate.toString(),
            ),
            kGap10,
            /// write review
            int.parse(order.orderStatus) == 2 ? GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    elevation: 10,
                    showDragHandle: true,
                    isScrollControlled: false,
                    barrierColor: Colors.black12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    builder: (context) {
                      return DraggableScrollableSheet(
                          initialChildSize: 1,
                          expand: true,
                          builder: (context , scroll) {
                            return RatingSheet(
                              orderId: order.orderId,
                              productId: order.productId,
                            );
                          },
                      );
                    }
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: blueColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      int.parse(order.orderStatus) == 3 ? "Review Added Successfully" : "Write Review",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                      ),
                  ),
                  ),
                ),
              ),
            ) : const SizedBox.shrink(),
            kGap10,
            /// cancel order
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                    child: Text(
                    "Cancel Order",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                    ),
                    ),
                ),
              ),
            ),
            kGap10,
          ],
        ),
      ),
    );
  }
}


