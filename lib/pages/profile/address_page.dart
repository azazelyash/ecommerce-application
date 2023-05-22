import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/pages/profile/edit_address_page.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:abhyukthafoods/utils/constants.dart';
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
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: FutureBuilder(
                future: SharedService.customerDetails(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    String address = " ";
                    // String address = "${snapshot.data!.billing['address_1']}, ${snapshot.data!.billing['address_2']}, ${snapshot.data!.billing['city']}, ${snapshot.data!.billing['state']}, ${snapshot.data!.billing['postcode']}, ${snapshot.data!.billing['country']}";
                    return ListView(
                      shrinkWrap: true,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Shipping Address",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: kPrimaryColor,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          " ",
                          // snapshot.data!.billing['first_name'] + " " + snapshot.data!.billing['last_name'],
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
                              label: Icon(
                                Icons.edit,
                                size: 18,
                                color: kPrimaryColor,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const EditAddressPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
