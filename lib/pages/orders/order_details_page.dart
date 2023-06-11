import 'dart:developer';

import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.order});
  final Order order;

  String resolveAddress(Order order) {
    Address address = order.shippingAddress;
    String result = '${address.firstname} ${address.lastname}\n';
    result += address.addr1.isEmpty ? '' : address.addr1;
    result += addAddress(result, address.addr2);
    result += addAddress(result, address.city);
    result += addAddress(result, address.state);
    result += addAddress(result, address.postcode);
    return result;
  }

  String addAddress(String result, String subfield) {
    return subfield.isEmpty ? '' : ', $subfield';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(title: 'Order No: ${order.id}'),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // StandardAppBar(title: 'Order No: ${order.id}'),
          OrderDetailsCard(order: order),
          Container(
            margin: const EdgeInsets.all(10),
            child: Card(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Delivery Address',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: SvgPicture.asset('assets/Icons/mdi_address-marker.svg'),
                      ),
                      Expanded(child: Text(resolveAddress(order))),
                    ],
                  )
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderDetailsCard extends StatelessWidget {
  const OrderDetailsCard({super.key, required this.order});
  final Order order;
  static const buttonRadius = BorderRadius.all(Radius.circular(10));

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Expanded(
                        child: Text('Order Status'),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: buttonRadius,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Text(
                          order.status[0].toUpperCase() + order.status.substring(1),
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Text(
                        formatDate(order.dateCreated),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Text(
                      "Rs. ${order.total}",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              ...order.itemList
                  .map(
                    (e) => Column(
                      children: [
                        ListTile(
                          title: Text(
                            '${e.name} x ${e.quantity}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          trailing: Text('Rs ${e.total}'),
                        ),
                        if (order.itemList.length > 1)
                          Row(
                            children: List.generate(
                              90,
                              (index) => Expanded(
                                child: Container(
                                  color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                  .toList(),
              /* ----------------------------- Reorder Button ----------------------------- */

              // const Divider(),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       const Expanded(child: Text('Rate')),
              //       ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           shape: RoundedRectangleBorder(borderRadius: buttonRadius),
              //           backgroundColor: Colors.black,
              //         ),
              //         onPressed: () {},
              //         child: const Text('Reorder'),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
