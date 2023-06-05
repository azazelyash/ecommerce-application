import 'dart:developer';

import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/order.dart';
import 'package:abhyukthafoods/network/fetch_orders.dart';
import 'package:abhyukthafoods/pages/orders/order_details_page.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key, this.customerModel});
  final CustomerModel? customerModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Past Orders',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              child: FutureBuilder(
                future: fetchOrders(customerModel!.id.toString()),
                builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : !snapshot.hasData
                        ? const Center(
                            child: Text(
                              'No data',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        : ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) => OrderCard(order: snapshot.data![index]),
                          ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});
  final Order order;
  static const buttonRadius = BorderRadius.all(Radius.circular(10));

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute}';
  }

  @override
  Widget build(BuildContext context) {
    log(order.dateCreated);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(
                order: order,
              ),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
                      Expanded(
                        child: Text('Order No. ${order.id}'),
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
