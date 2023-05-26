import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/order.dart';
import 'package:abhyukthafoods/network/fetch_orders.dart';
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
        child: CustomScrollView(slivers: [
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
                          child: Text('No data'),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => OrderCard(order: snapshot.data![index]),
                        ),
            ),
          )
        ]),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});
  final Order order;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: Padding(padding: const EdgeInsets.all(10), child: Text('Order No. ${order.id}'))),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(onPressed: () {}, child: Text(order.status)),
                )
              ],
            ),
          ),
          ...order.itemList
              .map(
                (e) => Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // child: Image.asset('assets/Rectangle 33.png'),
                      ),
                      title: Text('${e.name}  x${e.quantity}', style: Theme.of(context).textTheme.titleSmall),
                      trailing: Text('Rs ${e.total}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: List.generate(
                            90,
                            (index) => Expanded(
                                  child: Container(
                                    color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                                    height: 1,
                                  ),
                                )),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Expanded(child: Text('${order.dateCreated}')), Text('${order.total}')],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Expanded(child: Text('Rate')),
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black), onPressed: () {}, child: const Text('Reorder')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
