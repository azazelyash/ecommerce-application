import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddressAppBar(title: "Address"),
      body: const AddressView(),
    );
  }
}

class AddressView extends StatelessWidget {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Saved Address",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "2/55 Kala Kuan, Housing Board, Near Vidhya Public School, Alwar, Rajasthan, 301001",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                FloatingActionButton.extended(
                  heroTag: "delete",
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.grey.shade100,
                  label: const Icon(
                    Icons.delete,
                    size: 18,
                    color: Colors.red,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(
                  width: 16,
                ),
                FloatingActionButton.extended(
                  heroTag: "edit",
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.grey.shade100,
                  label: const Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
