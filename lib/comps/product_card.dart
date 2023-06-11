import 'dart:developer';

import 'package:abhyukthafoods/models/cart.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/products.dart';
import 'package:abhyukthafoods/pages/payment_order/confirm_order_page.dart';
import 'package:abhyukthafoods/pages/product_page/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.customerModel,
    super.key,
  });
  final Product product;
  final isLiked = false;
  final CustomerModel customerModel;

  String resolvePrice(Product product) {
    String price = '';

    if (product.price != '') {
      price += '₹${product.price}';
    } else if (product.regularPrice != '') {
      price += '₹${product.regularPrice}';
    } else if (product.salePrice != '') {
      price += '₹${product.salePrice}';
    } else {
      return 'No Price set';
    }
    if (product.variations!.isNotEmpty) {
      return 'Starting at $price';
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    CartDetails cartItem = CartDetails(
      id: product.id,
      quantity: 1,
      name: product.name,
      price: product.price,
      image: product.images!.isEmpty ? "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg" : product.images![0]['src'],
      description: product.description,
    );
    log(product.images.toString());
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductPage(product: product, customerModel: customerModel),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /* ---------------------------- Favourite Button ---------------------------- */

            // Row(
            //   children: [
            //     const Spacer(),
            //     IconButton(
            //       onPressed: () {},
            //       icon: SvgPicture.asset(height: 20, 'assets/Icons/love.svg'),
            //     )
            //   ],
            // ),

            /* ---------------------------------- Image --------------------------------- */

            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: product.images != null && product.images!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            product.images![0]['src'],
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: const Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg",
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              product.name,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              resolvePrice(product),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                if (product.variations!.isEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmOrderPage(
                        customerModel: customerModel,
                        products: [cartItem],
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPage(product: product, customerModel: customerModel),
                    ),
                  );
                }
              },
              child: const Center(
                child: Text(
                  "Buy",
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
