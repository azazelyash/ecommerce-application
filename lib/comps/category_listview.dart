import 'dart:math';

import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({super.key, required this.categories});
  final categories;
  Color generateRandomLightColor() {
    final random = Random();
    final r = 200 + random.nextInt(56); // random value between 200-255
    final g = 200 + random.nextInt(56);
    final b = 200 + random.nextInt(56);
    return Color.fromRGBO(r, g, b, 1.0);
  }

  Widget category(BuildContext context, int index, List categories) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: generateRandomLightColor(),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(7),
            height: 70,
            width: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: const Image(
                fit: BoxFit.cover,
                image: AssetImage('assets/Rectangle 33.png'),

                // NetworkImage(snapshot.data[index].image['src']),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            // snapshot.data[index].name,
            categories[index].toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 8),
        // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 100,
        width: double.infinity,
        color: Colors.white,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          physics: const PageScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return category(context, index, categories);
          },
        ));
  }
}