import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OrderTimeLine extends StatelessWidget {
  const OrderTimeLine({
    super.key,
    required this.order,
    required this.deliveryDate,
  });
  final String order;
  final String deliveryDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Step 0: Preparing
              CircleAvatar(
                backgroundColor: int.parse(order) >= 0 ? Colors.green : Colors.grey,
                radius: 20,
                child: Lottie.asset(
                  "assets/Lottie/perparing.json",
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              _buildConnector(int.parse(order) >= 1),
              /// Step 1: Shipping
              CircleAvatar(
                backgroundColor: int.parse(order) >= 1 ? Colors.green : Colors.grey,
                radius: 20,
                child: Lottie.asset(
                  "assets/Lottie/shipping.json",
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              _buildConnector(int.parse(order) >= 2),
              /// Step 2: Completed
              CircleAvatar(
                backgroundColor: int.parse(order) >= 2 ? Colors.green : Colors.grey,
                radius: 20,
                child: const Icon(
                  CupertinoIcons.checkmark_alt,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildConnector(bool isActive) {
  return AnimatedContainer(
    width: 100,
    height: 5,
    duration: const Duration(seconds: 1),
    curve: Curves.linear,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: isActive ? Colors.green : Colors.grey.shade400,
    ),
  );
}

