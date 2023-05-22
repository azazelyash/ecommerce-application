import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAddressPage extends StatelessWidget {
  const EditAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AddressAppBar(title: "Edit Shipping Address"),
      body: const EditAddressPageBody(),
    );
  }
}

class EditAddressPageBody extends StatefulWidget {
  const EditAddressPageBody({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
        future: SharedService.customerDetails(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            firstNameController.text = snapshot.data!.firstname.toString();
            lastNameController.text = snapshot.data!.lastname.toString();
            emailController.text = snapshot.data!.email.toString();
            // phoneController.text = snapshot.data!.billing['phone'].toString();
            // addressController.text = snapshot.data!.billing['address_1'].toString();
            // cityController.text = snapshot.data!.billing['city'].toString();
            // stateController.text = snapshot.data!.billing['state'].toString();
            // pincodeController.text = snapshot.data!.billing['postcode'].toString();
            // countryController.text = snapshot.data!.billing['country'].toString();

            return ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
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
                    onPressed: () {},
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
              ],
            );
          }
        },
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
