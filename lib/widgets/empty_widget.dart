import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shop/PROVIDERS/theme_provider.dart';
import 'package:smart_shop/root_screen.dart';

import '../core/text_widget.dart';

class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.buttonTitle,
  });

  final String image, title, subTitle, buttonTitle;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitlesTextWidget(
              label: title,
              // color: Colors.black,
              fontSize: 15,
            ),
            const SizedBox(
              height: 10,
            ),
            SubtitleTextWidget(
              label: subTitle,
              fontSize: 10,
            ),
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              image,
              height: 140,
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.getIsDarkTheme
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, RootScreen.routeName);
                },
                child: Text(
                  buttonTitle,
                  style: TextStyle(
                    fontSize: 15,
                    color: themeProvider.getIsDarkTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
