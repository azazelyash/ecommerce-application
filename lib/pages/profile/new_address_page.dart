import 'dart:developer';

import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/comps/loadingIndicator.dart';
import 'package:abhyukthafoods/models/address.dart';
import 'package:abhyukthafoods/pages/profile/gps_location.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:abhyukthafoods/services/location.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:abhyukthafoods/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';

class NewAddressPage extends StatelessWidget {
  NewAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AddressAppBar(title: "Add Shipping Address"),
      body: NewAddressPageBody(),
    );
  }
}

class NewAddressPageBody extends StatefulWidget {
  NewAddressPageBody({super.key});

  @override
  State<NewAddressPageBody> createState() => _NewAddressPageBodyState();
}

class _NewAddressPageBodyState extends State<NewAddressPageBody> {
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

  bool isFilled() {
    if (firstNameController.text.isNotEmpty && lastNameController.text.isNotEmpty && phoneController.text.isNotEmpty && emailController.text.isNotEmpty && addressController.text.isNotEmpty && cityController.text.isNotEmpty && stateController.text.isNotEmpty && pincodeController.text.isNotEmpty && countryController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  /* ----------------------- Check Username and Password ---------------------- */

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  OverlayEntry? loadingOverlayEntry;

  void showLoadingOverlay(BuildContext context) {
    final overlayState = Overlay.of(context)!;
    loadingOverlayEntry = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black54,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    overlayState.insert(loadingOverlayEntry!);
  }

  void hideLoadingOverlay() {
    if (loadingOverlayEntry != null) {
      loadingOverlayEntry!.remove();
      loadingOverlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 16,
          ),
          /* ------------------------------ GPS Navigator ----------------------------- */

          GestureDetector(
            onTap: () async {
              loadingIndicator(context);
              Placemark placemark = await LocationService().fillAddressFields();

              /* --------------------------- Fill Address Fields -------------------------- */

              addressController.text = placemark.street.toString();
              cityController.text = placemark.locality.toString();
              stateController.text = placemark.administrativeArea.toString();
              pincodeController.text = placemark.postalCode.toString();
              countryController.text = placemark.isoCountryCode.toString();

              setState(() {});

              if (!mounted) return;
              Navigator.pop(context);
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
                        Icons.gps_fixed,
                        color: kPrimaryColor,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Use GPS to Fill Address",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          addressPageFields("First Name", firstNameController, TextInputType.name),
          addressPageFields("Last Name", lastNameController, TextInputType.name),
          addressPageFields("Phone", phoneController, TextInputType.phone),
          addressPageFields("Email", emailController, TextInputType.emailAddress),
          addressPageFields("Address", addressController, TextInputType.streetAddress),
          addressPageFields("City", cityController, TextInputType.streetAddress),
          addressPageFields("State", stateController, TextInputType.streetAddress),
          addressPageFields("Pincode", pincodeController, TextInputType.number),
          addressPageFields("Country", countryController, TextInputType.streetAddress),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: FloatingActionButton.extended(
              onPressed: () {
                if (!isFilled()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text("All fields are Mandatory"),
                        ],
                      ),
                    ),
                  );
                  return;
                } else if (!isValidEmail(emailController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text("Invalid Email"),
                        ],
                      ),
                    ),
                  );
                  return;
                }
                loadingIndicator(context);

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

                APIService().addFirebaseAddress(billing);

                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text("Address Updated"),
                      content: const Text("Your address has been updated successfully"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            Navigator.pop(context, true);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget addressPageFields(String title, TextEditingController? controller, TextInputType keyboardType) {
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
