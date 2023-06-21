import 'dart:developer';

import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/models/address.dart';
import 'package:abhyukthafoods/models/firebase_address.dart';
import 'package:abhyukthafoods/models/order_model.dart';
import 'package:abhyukthafoods/pages/profile/edit_address_page.dart';
import 'package:abhyukthafoods/pages/profile/new_address_page.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:abhyukthafoods/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectDeliveryAddressPage extends StatefulWidget {
  const SelectDeliveryAddressPage({super.key});

  @override
  State<SelectDeliveryAddressPage> createState() => _SelectDeliveryAddressPageState();
}

class _SelectDeliveryAddressPageState extends State<SelectDeliveryAddressPage> {
  String chosenAddress = "";
  Billing billing = Billing();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StandardAppBar(title: "Select Delivery Address"),
      backgroundColor: Colors.white,
      body: deliveryAddressPageBody(),
      bottomNavigationBar: paymentButton(),
    );
  }

  void setAddress(Billing billingData) {
    billing.address1 = billingData.address1;
    billing.city = billingData.city;
    billing.country = billingData.country;
    billing.firstName = billingData.firstName;
    billing.lastName = billingData.lastName;
    billing.postcode = billingData.postcode;
    billing.state = billingData.state;
    billing.email = billingData.email;
    billing.phone = billingData.phone;
  }

  Widget deliveryAddressPageBody() {
    Color? color = kPrimaryColor.withOpacity(0.5);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          // shrinkWrap: true,
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

            /* ------------------------- Add New Address Button ------------------------- */

            GestureDetector(
              onTap: () async {
                bool ref = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => NewAddressPage(),
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
                          "Add New Address",
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
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: APIService().fetchFirebaseAddress(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  chosenAddress = snapshot.data![0].id!;
                  setAddress(snapshot.data![0].billing!);
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setAddress(snapshot.data![index].billing!);
                              setState(() {
                                // color = kPrimaryColor;
                                chosenAddress = snapshot.data![index].id!;
                                log("Chosen Address : $chosenAddress");
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                border: Border.all(
                                  color: (chosenAddress == snapshot.data![index].id!) ? color : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (chosenAddress == snapshot.data![index].id!) ? color : Colors.grey.shade300,
                                    blurRadius: 4,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width - 120,
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
                                            "${snapshot.data![index].billing!.firstName!} ${snapshot.data![index].billing!.lastName!}",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            "${snapshot.data![index].billing!.address1}, ${snapshot.data![index].billing!.city}, ${snapshot.data![index].billing!.state}, ${snapshot.data![index].billing!.postcode}, ${snapshot.data![index].billing!.country}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            "Contact No.: ${snapshot.data![index].billing!.phone}",
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
                                              /* ------------------------------ Delete Button ----------------------------- */
                                              SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: FloatingActionButton(
                                                  heroTag: "${index}Delete",
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  backgroundColor: Colors.grey.shade100,
                                                  child: SvgPicture.asset("assets/Icons/delete red.svg"),
                                                  onPressed: () async {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext dialogContext) {
                                                        return AlertDialog(
                                                          title: const Text("Delete Address"),
                                                          content: const Text("Are you sure you want to delete this address?"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(dialogContext);
                                                              },
                                                              child: const Text("No"),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                APIService().deleteFirebaseAddress(snapshot.data![index].id!);
                                                                this.setState(() {});
                                                                Navigator.pop(dialogContext);
                                                              },
                                                              child: const Text("Yes"),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),

                                              /* ------------------------------- Edit Button ------------------------------ */
                                              SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: FloatingActionButton(
                                                  heroTag: "${index}Edit",
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
                                                          documentId: snapshot.data![index].id!,
                                                        ),
                                                      ),
                                                    );

                                                    if (ref) {
                                                      setState(() {});
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Radio(
                                      fillColor: MaterialStateProperty.all(kPrimaryColor),
                                      value: snapshot.data![index].id!,
                                      groupValue: chosenAddress,
                                      onChanged: (value) {
                                        setState(() {
                                          chosenAddress = snapshot.data![index].id!;
                                        });
                                        log("Chosen Address : $chosenAddress");
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
            // const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget paymentButton() {
    return Container(
      // color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: FloatingActionButton.extended(
        heroTag: "Payment",
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
        onPressed: () {
          log("Billing Address at SELECT DELIVERY ADDRESS PAGE : ${billing.toJson().toString()}");
          Navigator.pop(context, billing);
        },
        label: const Text("Save Address"),
      ),
    );
  }
}
