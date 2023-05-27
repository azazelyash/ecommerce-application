import 'dart:developer';
import 'package:abhyukthafoods/models/order_model.dart';
import 'package:abhyukthafoods/pages/payment_order/order_success.dart';
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

  void paymentSuccess(PaymentSuccessResponse response, BuildContext context) {
    log("Success: ${response.paymentId}");
    OrderModel orderModel = OrderModel();
    orderModel.paymentMethod = "razorpay";
    orderModel.paymentMethodTitle = "RazorPay";
    orderModel.setPaid = true;
    orderModel.transactionId = response.paymentId.toString();

    log("Order ID: ${orderModel.orderId}");
    log("Order TrasactionId: ${orderModel.transactionId}");
  }

  void paymentError(PaymentFailureResponse response) {
    log("Error: ${response.message} - ${response.code}");
  }

  getPayment(int amount, String? phone, String? email) {
    var options = {
      'key': 'rzp_test_ON820cOfjs8bJX',
      'amount': amount * 100,
      'description': 'Test Payment',
      'prefill': {
        'contact': phone,
        'email': email,
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
