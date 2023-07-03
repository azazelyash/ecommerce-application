import 'dart:async';
import 'dart:developer';

import 'package:abhyukthafoods/comps/loadingIndicator.dart';
import 'package:abhyukthafoods/comps/navbar.dart';
import 'package:abhyukthafoods/comps/text_styles.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/login_model.dart';
import 'package:abhyukthafoods/pages/auth/firebase_login_credential_page.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:abhyukthafoods/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class LoginOTPVerificationPage extends StatefulWidget {
  LoginOTPVerificationPage(
      {super.key, required this.verificationId, required this.phone});

  String verificationId;
  String phone;

  @override
  State<LoginOTPVerificationPage> createState() =>
      _LoginOTPVerificationPageState();
}

class _LoginOTPVerificationPageState extends State<LoginOTPVerificationPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  CustomerModel customerModel = CustomerModel();
  bool isOTPSent = false;
  int _resendTimer = 30;
  Timer? _timer;

  Future<void> getCustomerData() async {
    customerModel = await SharedService.customerDetails();
    /* -------------------------- print customer model -------------------------- */
    log("Customer Model: ${customerModel.toJson()}");
  }

  void verifyOtp(String code) async {
    try {
      loadingIndicator(context);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: code);

      UserCredential user = await auth.signInWithCredential(credential);

      LoginResponseModel model =
          await APIService().fetchEmailPassword(user.user!.uid);

      if (model.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Invalid Number"),
              ],
            ),
          ),
        );

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        return;
      }

      getCustomerData();

      if (!mounted) return;
      log("Doc ID: ${user.user!.uid}");

      // Navigator.of(context).pop();
      log(model.statusCode.toString());

      if (model.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => MainPage(
                customerModel:
                    customerModel), // Replace with your homepage widget
          ),
        );
      } else {
        // Display Snackbar for wrong OTP
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Wrong OTP. Please try again."),
          ),
        );
      }

      // if (!mounted) return;
      // Navigator.pop(context);

      log("Signed In");
    } catch (e) {
      log("Verification Error: $e");
      log("Phone number does not exist");
      // Phone number doesn't exist, show a dialog box
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("OTP Invalid"),
            content:
                Text("Please enter the correct otp that sent to your number."),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          image: const AssetImage("assets/forgot_password/Background.png"),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Enter OTP",
                      style: kauthTextFieldStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  "An email has been sent to your registered email address. Please enter the OTP to reset your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 320,
                      child: OtpTextField(
                        numberOfFields: 6,
                        borderColor: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        showFieldAsBox: true,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        margin: const EdgeInsets.all(0),
                        borderWidth: 2,
                        enabledBorderColor: Colors.white,
                        keyboardType: TextInputType.number,
                        focusedBorderColor: kPrimaryColor,
                        fillColor: Colors.white,
                        filled: true,
                        onSubmit: (value) {
                          log("OTP: $value");
                          verifyOtp(value);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    // GestureDetector(
                    //   onTap: _resendTimer == 0 ? null : null,
                    //   child: Text(
                    //     _resendTimer == 0 ? 'Resend OTP' : 'Resend in $_resendTimer seconds',
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w500,
                    //       color: _resendTimer == 0 ? Colors.white : Colors.white54,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
