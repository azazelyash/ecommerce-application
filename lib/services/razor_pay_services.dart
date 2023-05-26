import 'dart:developer';

import 'package:abhyukthafoods/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayService {
  final Razorpay _razorpay = Razorpay();

  initPaymentGateway() {
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWallet);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentError);
  }

  void externalWallet(ExternalWalletResponse response) {
    log(response.walletName.toString());
  }

  OrderModel paymentSuccess(PaymentSuccessResponse response) {
    log("Success: ${response.paymentId}");
    OrderModel orderModel = OrderModel();
    orderModel.paymentMethod = "razorpay";
    orderModel.paymentMethodTitle = "RazorPay";
    orderModel.setPaid = true;
    orderModel.transactionId = response.paymentId.toString();

    return orderModel;
  }

  void paymentError(PaymentFailureResponse response) {
    log("Error: ${response.message} - ${response.code}");
  }

  getPayment(BuildContext context) {
    var options = {
      'key': 'rzp_live_9hEjbyS7CoAypM',
      'amount': 100,
      'description': 'Test Payment',
      'prefill': {
        'contact': '1234567890',
        'email': 'jss.yash085@gmail.com',
      },
      'name': 'SkyGoal',
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      log(e.toString());
    }
  }
}
