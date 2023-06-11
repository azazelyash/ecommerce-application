import 'dart:developer';

import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/pages/profile/edit_address_page.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:abhyukthafoods/utils/constants.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget {
  AddressPage({super.key, required this.id});

  String id;

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddressAppBar(title: "Address"),
      body: AddressView(id: widget.id),
    );
  }
}

class AddressView extends StatefulWidget {
  AddressView({super.key, required this.id});

  String id;

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
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
                future: SharedService.addressDetails(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    log("no data");
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
                                id: widget.id,
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
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        // shrinkWrap: true,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          SizedBox(
                            width: 60,
                            child: FloatingActionButton(
                              heroTag: "edit",
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.grey.shade100,
                              child: Icon(
                                Icons.edit,
                                size: 18,
                                color: kPrimaryColor,
                              ),
                              onPressed: () async {
                                bool ref = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => EditAddressPage(
                                      id: widget.id,
                                    ),
                                  ),
                                );

                                if (ref) {
                                  setState(() {});
                                }
                              },
                            ),
                          )
                        ],
                      ),
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
