import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_shop/SCREENS/search_screen.dart';

class CategoryRoundedWidget extends StatelessWidget {
  const CategoryRoundedWidget({
    super.key,
    required this.image,
    required this.name,
  });

  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          SearchScreen.routName,
          arguments: name,
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade200,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                image,
                width: 150,
                height: 150,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          //abel
          Text(name,
              style: GoogleFonts.alatsi(
                // fontWeight: FontWeight.bold,
                fontSize: 13,
              )),
        ],
      ),
    );
  }
}

//////////////////////////////////////// Search Category ///////////////////////////////////////////////////////////////
class CategorySearchWidget extends StatelessWidget {
  const CategorySearchWidget({
    super.key,
    required this.name,
  });
  final String name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          SearchScreen.routName,
          arguments: name,
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200, width: 2),
                color: Colors.grey.shade100,
              ),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
