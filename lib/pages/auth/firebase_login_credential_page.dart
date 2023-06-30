import 'dart:developer';

import 'package:abhyukthafoods/comps/auth_text_field.dart';
import 'package:abhyukthafoods/comps/loadingIndicator.dart';
import 'package:abhyukthafoods/comps/navbar.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/login_model.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FirebaseLoginCredentialsEntry extends StatefulWidget {
  FirebaseLoginCredentialsEntry({super.key, required this.uid});

  String uid;

  @override
  State<FirebaseLoginCredentialsEntry> createState() => _FirebaseLoginCredentialsEntryState();
}

class _FirebaseLoginCredentialsEntryState extends State<FirebaseLoginCredentialsEntry> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cfmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  CustomerModel customerModel = CustomerModel();
  String? firstName;
  String? lastName;

  /* ---------------------------- Splits Full Name ---------------------------- */

  void separateFullName(String fullName) {
    List<String> nameParts = fullName.split(' ');

    if (nameParts.length > 1) {
      firstName = nameParts[0];
      lastName = nameParts.last;
    } else {
      firstName = fullName;
      lastName = " ";
    }
  }

  /* ----------------------------- Checks Validity ---------------------------- */

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool passwordDoesNotMatch(String password, String cfmPassword) {
    if (password != cfmPassword) {
      return true;
    }

    return false;
  }

  bool isFieldEmpty() {
    if (emailController.text == "" || passwordController.text == "" || cfmPasswordController.text == "" || nameController.text == "") {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/Icons/bgg.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  children: [
                    //title
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Sign Up here",
                          style: GoogleFonts.dmSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                          textScaleFactor: 1.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: authTextFieldDecoration("Full Name"),
                      ),
                    ),
                    //textfields
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: authTextFieldDecoration("Email Id"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: passwordController,
                        style: const TextStyle(color: Colors.white),
                        decoration: authTextFieldDecoration("Password"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: cfmPasswordController,
                        style: const TextStyle(color: Colors.white),
                        decoration: authTextFieldDecoration("Confirm Password"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    /* ------------------------------ SignUp Button ----------------------------- */

                    //buttons
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          if (isFieldEmpty()) {
                            displaySnackBarMessage(context, "All Fields are Mandatory!");
                            return;
                          }
                          if (!isValidEmail(emailController.text)) {
                            displaySnackBarMessage(context, "Email is Invalid");
                            return;
                          }
                          if (passwordDoesNotMatch(passwordController.text, cfmPasswordController.text)) {
                            displaySnackBarMessage(context, "Passwords did not Match");
                            return;
                          }
                          separateFullName(nameController.text);
                          loadingIndicator(context);
                          signup();
                          // Navigator.pop(context);
                        },
                        child: Container(
                          width: 390,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Text(
                              "Submit",
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void displaySnackBarMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error),
            const SizedBox(
              width: 8,
            ),
            Text(
              text,
            ),
          ],
        ),
      ),
    );
  }

  void signup() async {
    APIService().saveLoginDataToFirebase(
      widget.uid,
      emailController.text,
      passwordController.text,
      firstName!,
      lastName!,
    );

    CustomerModel model = CustomerModel();
    model.email = emailController.text;
    model.firstname = firstName;
    model.lastname = lastName;
    model.password = passwordController.text;

    await APIService().createCustomer(model);

    signIn();
  }

  void signIn() async {
    // await APIService.newLoginCustomerUsingFirebase(
    //   emailController.text,
    //   passwordController.text,
    //   widget.uid,
    // );
    LoginResponseModel model = await APIService.newLoginCustomerUsingFirebase(
      emailController.text,
      passwordController.text,
      widget.uid,
    );
    getCustomerData();

    // if (!mounted) return;

    Navigator.of(context).pop();

    if (model.statusCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MainPage(customerModel: customerModel!), // Replace with your homepage widget
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Invalid Username or Password"),
        ),
      );
    }
  }

  Future<void> getCustomerData() async {
    customerModel = await SharedService.customerDetails();
    /* -------------------------- print customer model -------------------------- */
    log("Customer Model: ${customerModel!.toJson()}");
  }
}
