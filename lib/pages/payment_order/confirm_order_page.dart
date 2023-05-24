import 'dart:developer';

import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/models/cart.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/pages/profile/edit_address_page.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:abhyukthafoods/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

class ConfirmOrderPage extends StatefulWidget {
  ConfirmOrderPage({super.key, required this.customerModel, required this.products});

  CustomerModel customerModel;
  List<CartDetails> products = [];

  @override
  State<ConfirmOrderPage> createState() => ConfirmOrderPageState();
}

class ConfirmOrderPageState extends State<ConfirmOrderPage> {
  int totalAmt = 0;
  int couponAmount = 0;
  int payableAmount = 0;

  int calculatePrice(int price, int quantity) {
    return price * quantity;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.products.isEmpty) {
      log("Empty");
      Navigator.pop(context, true);
    }
  }

  void totalAmount() {
    int total = 0;
    for (int i = 0; i < widget.products.length; i++) {
      total += calculatePrice(int.parse(widget.products[i].price!), widget.products[i].quantity);
    }
    totalAmt = total;
  }

  void totalAmountAfterCoupon() {
    payableAmount = totalAmt - couponAmount;
  }

  void increaseQuantity(int index) {
    setState(() {
      widget.products[index].quantity++;
    });
  }

  void deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Delete Product"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.products.length == 1) {
                Navigator.pop(context, true);
                widget.products.removeAt(index);
              } else {
                setState(() {
                  widget.products.removeAt(index);
                });
              }
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void decreaseQuantity(int index) {
    if (widget.products[index].quantity == 1) {
      deleteProduct(index);
      return;
    }
    setState(() {
      widget.products[index].quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    log(widget.customerModel.id.toString());
    log(widget.products.length.toString());
    log(widget.products[0].image.toString());
    totalAmount();
    totalAmountAfterCoupon();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PaymentAppBar(title: "Confirm Order"),
      body: paymentGatewayBody(),
    );
  }

  Widget paymentGatewayBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        // mainAxisAlignment: MainAxisAlignment.start,
        shrinkWrap: true,
        children: [
          ListView.builder(
            itemCount: widget.products.length,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return productTile(context, index);
            },
          ),
          deliveryAddress(),
          const SizedBox(
            height: 20,
          ),
          priceSummary(),
          const SizedBox(
            height: 20,
          ),
          paymentButton(),
        ],
      ),
    );
  }

  Container productTile(BuildContext context, int index) {
    String name = widget.products[index].name;
    // String imageUrl = "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg";
    String imageUrl = (widget.products[index].image == null) ? "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg" : widget.products[index].image!;
    String quantity = widget.products[index].quantity.toString();
    String price = widget.products[index].price!;
    String description = widget.products[index].description!;
    int displayPrice = calculatePrice(int.parse(price), int.parse(quantity));
    log(index.toString());
    log("Name : $name, Image : $imageUrl, Quantity : $quantity, Price : $price, Description : $description, Display Price : $displayPrice");
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      width: MediaQuery.of(context).size.width,
      height: 124,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  image: NetworkImage(imageUrl),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "$quantity x $price",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      /* ------------------------ Decrease quantity Button ------------------------ */

                      GestureDetector(
                        onTap: () {
                          decreaseQuantity(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            // border: Border.all(color: Colors.grey.shade300),
                            color: Colors.grey.shade100,
                          ),
                          child: const Icon(Icons.remove),
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Text(
                        quantity,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      /* ------------------------ Increase quantity Button ------------------------ */

                      GestureDetector(
                        onTap: () {
                          increaseQuantity(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            // border: Border.all(color: Colors.grey.shade300),
                            color: Colors.grey.shade100,
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /* -------------------------- Product Delete Button ------------------------- */

              GestureDetector(
                onTap: () {
                  deleteProduct(index);
                },
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              Text(
                "₹ ${displayPrice.toString()}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container deliveryAddress() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Delivery Address",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: FutureBuilder(
              future: SharedService.addressDetails(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data!.address1 == "") {
                    return GestureDetector(
                      onTap: () async {
                        bool ref = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditAddressPage(
                              id: widget.customerModel.id.toString(),
                            ),
                          ),
                        );

                        if (ref) {
                          setState(() {});
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        // height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: kPrimaryColor,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "Add Address",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: kPrimaryColor,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  String name = "${snapshot.data!.firstName} ${snapshot.data!.lastName}";
                  String address = "${snapshot.data!.address1}, ${snapshot.data!.city}, ${snapshot.data!.state}, ${snapshot.data!.postcode}, ${snapshot.data!.country}";
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        address,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () async {
                          bool ref = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => EditAddressPage(
                                id: widget.customerModel.id.toString(),
                              ),
                            ),
                          );

                          if (ref) {
                            setState(() {});
                          }
                        },
                        child: Text(
                          "Change Address",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Container priceSummary() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Price Summary",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "₹ $totalAmt",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          dashedLine(context: context),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Coupon Discount",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "₹ $couponAmount",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          dashedLine(context: context),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Payable Amount",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "₹ $payableAmount",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton paymentButton() {
    return FloatingActionButton.extended(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: kPrimaryColor,
      elevation: 0,
      onPressed: () {},
      label: const Text("Proceed to Pay"),
    );
  }
}

class dashedLine extends StatelessWidget {
  const dashedLine({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return DottedLine(
      dashColor: Colors.grey.shade300,
      lineLength: MediaQuery.of(context).size.width - 72,
    );
  }
}
