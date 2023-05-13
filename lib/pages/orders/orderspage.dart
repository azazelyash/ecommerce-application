import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Past Orders',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              OrderCard()
            ],
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  OrderCard({super.key});
  final List<String> productList = ['a', 'b', 'c'];
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
                const Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Order No. #13123412'))),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text('Delivered')),
                )
              ],
            ),
          ),
          ...productList
              .map(
                (e) => Column(
                  children: [
                    ListTile(
                      leading: Container(
                          padding: const EdgeInsets.all(10),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset('assets/Rectangle 33.png')),
                      title: Text('Sunstar Fresh Melon Juice  x1',
                          style: Theme.of(context).textTheme.titleSmall),
                      trailing: const Text('Rs 200.55'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: List.generate(
                            90,
                            (index) => Expanded(
                                  child: Container(
                                    color: index % 2 == 0
                                        ? Colors.transparent
                                        : Colors.grey,
                                    height: 1,
                                  ),
                                )),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: Text('02-03-2023 : 12: 44 PM')),
                Text('Rs 200.55')
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Expanded(child: Text('Rate')),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () {},
                    child: const Text('Reorder')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}