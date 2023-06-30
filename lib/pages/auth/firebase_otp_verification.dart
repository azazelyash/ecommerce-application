import 'dart:async';
import 'dart:developer';

import 'package:abhyukthafoods/comps/loadingIndicator.dart';
import 'package:abhyukthafoods/comps/text_styles.dart';
import 'package:abhyukthafoods/pages/auth/firebase_login_credential_page.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:abhyukthafoods/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class FirebaseOTPVerificationPage extends StatefulWidget {
  FirebaseOTPVerificationPage({super.key, required this.verificationId, required this.phone});

  String verificationId;
  String phone;

  @override
  State<FirebaseOTPVerificationPage> createState() => _FirebaseOTPVerificationPageState();
}

class _FirebaseOTPVerificationPageState extends State<FirebaseOTPVerificationPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isOTPSent = false;
  int _resendTimer = 30;
  Timer? _timer;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   startResendTimer();
  // }

  // void resendOtp() async {
  //   startResendTimer();
  //   showDialog(
  //     context: context,
  //     builder: (context) => const Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );

  //   APIService().firebasePhoneAuth(widget.phone, context);

  //   Navigator.of(context).pop();
  // }

  // @override
  // void dispose() {
  //   _timer?.cancel();
  //   super.dispose();
  // }

  // void startResendTimer() {
  //   _resendTimer = 30;
  //   const duration = Duration(seconds: 1);
  //   _timer = Timer.periodic(duration, (Timer timer) {
  //     setState(() {
  //       if (_resendTimer > 0) {
  //         _resendTimer--;
  //       } else {
  //         timer.cancel();
  //       }
  //     });
  //   });
  // }

  void verifyOtp(String code) async {
    try {
      loadingIndicator(context);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: code);

      UserCredential user = await auth.signInWithCredential(credential);

      log(user.user!.uid.toString());

      if (!mounted) return;
      Navigator.pop(context);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FirebaseLoginCredentialsEntry(
            uid: user.user!.uid,
          ),
        ),
      );
    } catch (e) {
      log("Verification Error: $e");
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
                      style: kauthTextFieldStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
