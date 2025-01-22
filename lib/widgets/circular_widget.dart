import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingManager extends StatelessWidget {
  const LoadingManager(
      {super.key, required this.child, required this.isLoading});
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          Center(
                    child: SizedBox(
          height: 100,
          width: 100,
          child: LottieBuilder.asset(
                    "assets/Lottie/Loading.json",
                  ),
                    ),
                    ),
        ],
      ],
    );
  }
}
