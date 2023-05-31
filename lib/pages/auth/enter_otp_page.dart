import 'dart:async';
import 'dart:developer';

import 'package:abhyukthafoods/comps/text_styles.dart';
import 'package:abhyukthafoods/pages/auth/forgotpassword.dart';
import 'package:abhyukthafoods/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:email_otp/email_otp.dart';

class EnterOTPScreen extends StatefulWidget {
  const EnterOTPScreen({super.key, required this.id, required this.email});
  final int id;
  final String email;
  @override
  State<EnterOTPScreen> createState() => _EnterOTPScreenState();
}

class _EnterOTPScreenState extends State<EnterOTPScreen> {
  // EmailAuth emailAuth = EmailAuth(sessionName: "Abhyuktha Foods");
  EmailOTP emailOTP = EmailOTP();
  bool isOTPSent = false;
  int _resendTimer = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    sendOtp();
  }

  void sendOtp() async {
    startResendTimer();
    emailOTP.setConfig(
      appEmail: "sai@skygoalnext.com",
      appName: "Abhyuktha Foods",
      userEmail: widget.email,
      otpLength: 6,
      otpType: OTPType.digitsOnly,
    );
    emailOTP.setSMTP(
      host: "smtp-relay.sendinblue.com",
      port: 587,
      username: "sai@skygoalnext.com",
      password: "RsXJ6VmfCBFv2A5K",
      auth: true,
      secure: "AUTO",
    );
    setState(() {
      isOTPSent = true;
    });
    bool result = await emailOTP.sendOTP();

    if (result) {
      log("OTP sent");
      setState(() {
        isOTPSent = true;
      });
    } else {
      log("OTP not sent");
      setState(() {
        isOTPSent = true;
      });
    }
  }

  void resendOtp() async {
    startResendTimer();
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    emailOTP.setConfig(
      appEmail: "sai@skygoalnext.com",
      appName: "Abhyuktha Foods",
      userEmail: widget.email,
      otpLength: 6,
      otpType: OTPType.digitsOnly,
    );
    emailOTP.setSMTP(
      host: "smtp-relay.sendinblue.com",
      port: 587,
      username: "sai@skygoalnext.com",
      password: "RsXJ6VmfCBFv2A5K",
      auth: true,
      secure: "AUTO",
    );
    setState(() {
      isOTPSent = true;
    });
    bool result = await emailOTP.sendOTP();
    Navigator.pop(context);

    if (result) {
      log("OTP sent");
      setState(() {
        isOTPSent = true;
      });
    } else {
      log("OTP not sent");
      setState(() {
        isOTPSent = true;
      });
    }
  }

  void verifyOtp(String value) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      ),
    );
    bool result = await emailOTP.verifyOTP(otp: value);
    if (!mounted) return;
    Navigator.pop(context);
    if (result) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordPage(id: widget.id),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade600,
          content: const Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.white,
              ),
              SizedBox(
                width: 12,
              ),
              Text("Invalid OTP"),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startResendTimer() {
    _resendTimer = 30;
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    log("ID: ${widget.id}");
    log("Email: ${widget.email}");

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
          body: otpPageBody(),
        ),
      ],
    );
  }

  Widget otpPageBody() {
    return Padding(
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
              GestureDetector(
                onTap: _resendTimer == 0 ? resendOtp : null,
                child: Text(
                  _resendTimer == 0 ? 'Resend OTP' : 'Resend in $_resendTimer seconds',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _resendTimer == 0 ? Colors.white : Colors.white54,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// emailOTP.setSMTP(
//   host: "http://smtp-relay.sendinblue.com/",
//   port: 587,
//   username: "sai@skygoalnext.com",
//   auth: true,
//   password: "RsXJ6VmfCBFv2A5K",
//   secure: "TLS",
// );
    