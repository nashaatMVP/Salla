import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:salla/shared/app/constants.dart';
import 'package:salla/shared/app/custom_appbar.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../shared/app/custom_text.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/app/custom_empty_widget.dart';
import 'order_widget.dart';

class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreenFree({Key? key}) : super(key: key);

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(onDelete: () {}, text: "Orders"),

      body: StreamBuilder<List<OrderModelAdvanced>>(
        stream: orderProvider.fetchOrdersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print(snapshot.connectionState);
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("${snapshot.error}");
            return SelectableText(
              snapshot.error.toString(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyBagWidget(
              isCart: false,
              buttonTitle: "shop now",
              title: "Empty Orders",
              subTitle: "select order and enjoy the quality",
            );
          }
          print(snapshot.data!.length);
          return Column(
            children: [
              kGap20,
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Chip(
                      label: Text("Perparing"),
                    ),
                    Chip(
                      label: Text("Compelted"),
                    ),
                    Chip(
                      label: Text("Cancelled"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                      child: OrderWidget(
                        orderModelAdvanced: snapshot.data![index],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
