import 'dart:developer';

import 'package:abhyukthafoods/models/cart.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/network/fetch_products.dart';
import 'package:abhyukthafoods/pages/payment_order/confirm_order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.customerModel});
  final CustomerModel customerModel;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int totalPrice() {
    int total = 0;
    for (var item in cartItems) {
      total += int.parse(item.price!) * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    log(cartItems.length.toString());
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Text(
                  "Cart",
                  style: GoogleFonts.dmSans(
                      fontSize: 25, fontWeight: FontWeight.w700),
                ),
              ),
              (cartItems.isEmpty)
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 96.0),
                      child: Center(
                        child: Text(
                          "Your cart is empty",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: cartItems.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CartCard(
                          index: index,
                          deleteFunction: () {
                            setState(() {
                              Cart().removeItemFromCart(cartItems[index]);
                            });
                          },
                          increaseFunction: () {
                            setState(() {
                              Cart().increaseItemQuantity(cartItems[index]);
                            });
                          },
                          decreaseFunction: () {
                            setState(() {
                              Cart().decreaseItemQuantity(cartItems[index]);
                            });
                          },
                        );
                      },
                    ),
              const ApplyCouponBox(),
              EnterCouponBox(
                submit: () {},
              ),
              TotalBox(price: totalPrice()),

              /* ----------------------------- CheckOut Button ---------------------------- */

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: FloatingActionButton.extended(
                    onPressed: () async {
                      if (cartItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 1),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            content: Text("Your cart is empty"),
                          ),
                        );
                        return;
                      }
                      bool ref = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmOrderPage(
                            customerModel: widget.customerModel,
                            products: cartItems,
                          ),
                        ),
                      );

                      if (ref) {
                        setState(() {});
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.black,
                    label: Center(
                      child: Text(
                        "CHECKOUT",
                        style: GoogleFonts.dmSans(
                          color: Colors.grey.shade100,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartCard extends StatefulWidget {
  CartCard({
    Key? key,
    required this.index,
    required this.deleteFunction,
    required this.increaseFunction,
    required this.decreaseFunction,
  }) : super(key: key);

  final int index;
  final VoidCallback deleteFunction;
  final VoidCallback increaseFunction;
  final VoidCallback decreaseFunction;

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  int calculatePrice(int price, int quantity) {
    return price * quantity;
  }

  @override
  Widget build(BuildContext context) {
    String name = cartItems[widget.index].name;
    String imageUrl = (cartItems[widget.index].image == null)
        ? "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg"
        : cartItems[widget.index].image!;
    String quantity = cartItems[widget.index].quantity.toString();
    String price = cartItems[widget.index].price!;
    String description = cartItems[widget.index].description!;
    int displayPrice = calculatePrice(int.parse(price), int.parse(quantity));

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Stack(
          children: [
            Container(
              width: 390,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white54,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  children: [
                    // Picture
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(imageUrl),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              "$quantity",
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: widget.decreaseFunction),
                                  Text(
                                    quantity,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: widget.increaseFunction),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  displayPrice.toString(),
                                  style: GoogleFonts.dmSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textScaleFactor: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 330,
              top: 20,
              child: GestureDetector(
                onTap: widget.deleteFunction,
                child: SvgPicture.asset('assets/Icons/delete red.svg'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CartCardShimmer extends StatelessWidget {
  const CartCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Container(
            width: 390,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // Picture
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 180,
                        height: 16,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 12,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 50,
                            height: 16,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// apply box

class ApplyCouponBox extends StatelessWidget {
  const ApplyCouponBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 70,
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Apply Coupon",
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  textScaleFactor: 1.0,
                ),
                Text(
                  "Saved Amount : 0.00",
                  style: GoogleFonts.dmSans(
                    color: Colors.green.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textScaleFactor: 1.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// enter coupon

class EnterCouponBox extends StatelessWidget {
  const EnterCouponBox({Key? key, required this.submit});

  final VoidCallback submit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter coupon code",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "SUBMIT",
                        style: GoogleFonts.dmSans(
                          color: Colors.grey.shade100,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TotalBox extends StatefulWidget {
  const TotalBox({
    super.key,
    required this.price,
  });

  final int price;

  @override
  State<TotalBox> createState() => _TotalBoxState();
}

class _TotalBoxState extends State<TotalBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 70,
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Price",
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  textScaleFactor: 1.0,
                ),
                Text(
                  "₹ ${widget.price.toString()}",
                  style: GoogleFonts.dmSans(
                    color: Colors.green.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textScaleFactor: 1.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
