import 'dart:developer';

import 'package:abhyukthafoods/comps/navbar.dart';
import 'package:abhyukthafoods/models/cart.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/pages/orders/orderspage.dart';
import 'package:abhyukthafoods/pages/payment_order/confirm_order_page.dart';
import 'package:abhyukthafoods/utils/constants.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class OrderSuccessPage extends StatefulWidget {
  OrderSuccessPage({super.key, required this.customerModel, required this.products});

  CustomerModel customerModel;
  List<CartDetails> products;

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: successPageAppbar(context),
      backgroundColor: kPrimaryColor,
      body: successPageBody(context),
    );
  }

  Widget successPageBody(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage("assets/order/success.png"),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Order Placed Successfully",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Your Order Id 887644 is Successfully Placed",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final product = widget.products[index];
                  return productsCard(product);
                },
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            viewDetailsButton(context),
          ],
        ),
      ),
    );
  }

  FloatingActionButton viewDetailsButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Cart().clearCart();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(
              rerouteIndex: 3,
              customerModel: widget.customerModel,
            ),
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      label: const Row(
        children: [
          Text(
            "View Order",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget productsCard(CartDetails product) {
    log("Image URL : ${product.image}");
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 48,
                    width: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        image: NetworkImage(
                          (product.image == null) ? "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg" : product.image.toString(),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 160,
                        child: Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        " x ${product.quantity}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              // Text(
              //   "₹${product.price}",
              //   style: const TextStyle(
              //     color: Colors.white,
              //     fontSize: 18,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const DottedLine(
            dashColor: Colors.white,
            lineThickness: 0.5,
          ),
        ],
      ),
    );
  }

  AppBar successPageAppbar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () {
          Cart().clearCart();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(
                customerModel: widget.customerModel,
              ),
            ),
            (route) => false,
          );
        },
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }
}
