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
      image: product.images!.isEmpty ? null : product.images![0]['src'],
      description: product.description,
    );
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(product: product, customerModel: customerModel),
            )),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(height: 20, 'assets/Icons/love.svg'),
                  )
                ],
              ),
              Expanded(
                child: SizedBox(
                  width: 125,
                  child: product.images != null && product.images!.isNotEmpty
                      ? Image(fit: BoxFit.cover, image: NetworkImage(product.images![0]['src'])

                          // NetworkImage(snapshot.data[index].image['src']),
                          )
                      : const Placeholder(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                product.name,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                resolvePrice(product),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {},
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmOrderPage(
                          customerModel: customerModel,
                          products: [cartItem],
                        ),
                      ),
                    );
                  },
                  child: const Center(
                    child: Text(
                      "Buy",
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ])));
  }
}
