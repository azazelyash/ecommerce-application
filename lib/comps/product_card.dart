import 'package:abhyukthafoods/pages/product_page/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
  });
  final isLiked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      width: 180,
      child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductPage(),
              )),
          child: Stack(
            children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(children: [
                    const Expanded(
                      child: SizedBox(
                        width: 125,
                        child: Image(
                            fit: BoxFit.contain,
                            image: AssetImage('assets/Rectangle 33.png')
                            // NetworkImage(snapshot.data[index].images[0]['src']),
                            ),
                      ),
                    ),
                    const Text(
                      'Veg Pickle', // snapshot.data[index].name,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '400.00 - 1300.00', // snapshot.data[index].name,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        onPressed: () {},
                        child: const Center(
                          child: Text(
                            "Buy",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ])),
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(height: 20, 'assets/Icons/love.svg'),
                  )
                ],
              )
            ],
          )),
    );
  }
}
