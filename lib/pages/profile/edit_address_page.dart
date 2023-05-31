import 'dart:developer';

import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/models/address.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAddressPage extends StatelessWidget {
  EditAddressPage({super.key, required this.id});

  String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AddressAppBar(title: "Edit Shipping Address"),
      body: EditAddressPageBody(id: id),
    );
  }
}

class EditAddressPageBody extends StatefulWidget {
  EditAddressPageBody({super.key, required this.id});
  String id;
  @override
  State<EditAddressPageBody> createState() => _EditAddressPageBodyState();
}

class _EditAddressPageBodyState extends State<EditAddressPageBody> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  Billing billing = Billing();

  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
        future: SharedService.addressDetails(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            firstNameController.text = snapshot.data!.firstName.toString();
            lastNameController.text = snapshot.data!.lastName.toString();
            emailController.text = snapshot.data!.email.toString();
            phoneController.text = snapshot.data!.phone.toString();
            addressController.text = snapshot.data!.address1.toString();
            cityController.text = snapshot.data!.city.toString();
            stateController.text = snapshot.data!.state.toString();
            pincodeController.text = snapshot.data!.postcode.toString();
            countryController.text = snapshot.data!.country.toString();

            return ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                addressPageFields(
                    "First Name", firstNameController, TextInputType.name),
                addressPageFields(
                    "Last Name", lastNameController, TextInputType.name),
                addressPageFields(
                    "Phone", phoneController, TextInputType.phone),
                addressPageFields(
                    "Email", emailController, TextInputType.emailAddress),
                addressPageFields(
                    "Address", addressController, TextInputType.streetAddress),
                addressPageFields(
                    "City", cityController, TextInputType.streetAddress),
                addressPageFields(
                    "State", stateController, TextInputType.streetAddress),
                addressPageFields(
                    "Pincode", pincodeController, TextInputType.number),
                addressPageFields(
                    "Country", countryController, TextInputType.streetAddress),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      billing.firstName = firstNameController.text;
                      billing.lastName = lastNameController.text;
                      billing.email = emailController.text;
                      billing.phone = phoneController.text;
                      billing.address1 = addressController.text;
                      billing.city = cityController.text;
                      billing.state = stateController.text;
                      billing.postcode = pincodeController.text;
                      billing.country = countryController.text;

                      log("Billing Address at EDIT ADDRESS PAGE : ${billing.toJson().toString()}");

                      APIService.updateAddress(billing, id);

                      Navigator.pop(context);

                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text("Address Updated"),
                            content: const Text(
                                "Your address has been updated successfully"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.black,
                    label: Center(
                      child: Text(
                        "Save",
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
              ],
            );
          }
        },
      ),
    );
  }

  Widget addressPageFields(String title, TextEditingController? controller,
      TextInputType keyboardType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          keyboardType: keyboardType,
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter your $title",
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(
          height: 18,
        ),
      ],
    );
  }
}
