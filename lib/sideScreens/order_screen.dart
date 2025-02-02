import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../providers/order_provider.dart';
import '../shared/custom_text.dart';
import '../shared/theme/app_colors.dart';
import '../shared/custom_empty_widget.dart';
import '../widgets/itemWidgets/order_widget.dart';

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
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        title:  Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: TextWidgets.bodyText1("My Orders"),

        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon:  Icon(
              Icons.clear_all,
              color: appColors.primaryColor,
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<OrderModelAdvanced>>(
        stream: orderProvider.fetchOrdersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print(snapshot.connectionState);
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("${snapshot.error}7777777777777777");
            return SelectableText(
              snapshot.error.toString(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyBagWidget(
              image: "assets/bag/empty_order.png",
              buttonTitle: "shop now",
              title: "Empty Orders",
              subTitle: "select order and enjoy the quality",
            );
          }
          print(snapshot.data!.length);
          return ListView.separated(
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
              return  Divider(
                endIndent: 10,
                indent: 10,
                thickness: 1,
                color: appColors.primaryColor,
              );
            },
          );
        },
      ),
    );
  }
}
