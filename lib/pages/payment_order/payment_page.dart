import 'dart:developer';

import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/models/address.dart';
import 'package:abhyukthafoods/models/cart.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/order_model.dart';
import 'package:abhyukthafoods/pages/payment_order/order_success.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:abhyukthafoods/services/razor_pay_services.dart';
import 'package:abhyukthafoods/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

enum PaymentMethod { COD, RazorPay }

class PaymentPage extends StatefulWidget {
  PaymentPage({super.key, required this.payableAmount, required this.billing, required this.orderModel, required this.customerModel, required this.products, required this.couponDiscount});

  OrderModel orderModel;
  CustomerModel customerModel;
  List<CartDetails> products;
  Billing billing;
  double couponDiscount;
  double payableAmount;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? _paymentMethod = PaymentMethod.COD;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // log("Order ID: ${widget.orderModel.orderId}");
    // log("Order CustomerId: ${widget.orderModel.customerId}");
    // log("Order PaymentMethod: ${widget.orderModel.paymentMethod}");
    // log("--------------------");
    // for (var item in widget.orderModel.lineItems!) {
    //   log("Order Item: ${item.productId}");
    //   log("Order Item: ${item.quantity}");
    // }
    // log("Coupon Lines ------------- ${widget.orderModel.couponLines![0]}");
    return isLoading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: PaymentAppBar(title: "Payment Options"),
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                paymentOptions(),
                paymentButton(),
              ],
            ),
          );
  }

  Widget paymentOptions() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        paymentCard(imagePath: "assets/payment_options/money.svg", title: "Cash on Delivery", radioValue: PaymentMethod.COD),
        paymentCard(imagePath: "assets/payment_options/razorpay.svg", title: "RazorPay", radioValue: PaymentMethod.RazorPay),
      ],
    );
  }

  Widget paymentCard({required String imagePath, required String title, required PaymentMethod radioValue}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _paymentMethod = radioValue;
        });
      },
      child: Container(
        // color: Colors.cyan.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(imagePath),
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Radio<PaymentMethod>(
              value: radioValue,
              activeColor: kPrimaryColor,
              groupValue: _paymentMethod,
              onChanged: (value) {
                setState(() {
                  _paymentMethod = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void paymentSuccess(PaymentSuccessResponse response) async {
    // log("Success: ${response.paymentId}");

    // OrderModel orderModel = OrderModel();
    widget.orderModel.paymentMethod = "razorpay";
    widget.orderModel.paymentMethodTitle = "RazorPay";
    widget.orderModel.setPaid = true;
    widget.orderModel.transactionId = response.paymentId.toString();

    // log("Order ID: ${widget.orderModel.orderId}");
    // log("Order TrasactionId: ${widget.orderModel.transactionId}");
    var ret = await APIService.createOrder(widget.orderModel);
    if (ret) {
      log("Order Created Successfully");
      //loading ends
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OrderSuccessPage(
            customerModel: widget.customerModel,
            products: widget.products,
          ),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      Navigator.of(context).pop();

      Fluttertoast.showToast(msg: 'Order Creation Failed');

      log("Order Creation Failed");
    }
  }

  void paymentError(PaymentFailureResponse response) {
    setState(() {
      isLoading = false;
    });
    log("Razorpay Failed");
    Fluttertoast.showToast(msg: 'Payment Failed');
    log("Error: ${response.message} - ${response.code}");
  }

  Widget paymentButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: kPrimaryColor,
          elevation: 0,
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            // RazorPayService razorPayService = RazorPayService();
            // razorPayService.initPaymentGateway();
            // razorPayService.getPayment(context);

            for (var item in widget.orderModel.lineItems!) {
              log("Item: ${item.productId}");
              log("Item: ${item.quantity}");
            }

            double amount = 0;
            bool ret = false;

            for (var item in widget.products) {
              amount += double.parse(item.price!) * item.quantity;
            }

            amount -= widget.couponDiscount;

            if (_paymentMethod == PaymentMethod.COD) {
              widget.orderModel.paymentMethod = "cod";
              widget.orderModel.paymentMethodTitle = "Cash on Delivery";
              ret = await APIService.createOrder(widget.orderModel);
              if (ret) {
                log("Order Created Successfully");
                if (!mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => OrderSuccessPage(
                      customerModel: widget.customerModel,
                      products: widget.products,
                    ),
                  ),
                );
              } else {
                isLoading = false;
                Fluttertoast.showToast(msg: 'Order Creation Failed, try again later');
                log("Order Creation Failed");
              }
            } else {
              widget.orderModel.paymentMethod = "razorpay";
              widget.orderModel.paymentMethodTitle = "RazorPay";
              RazorPayService razorPayService = RazorPayService();
              razorPayService.initPaymentGateway(paymentSuccess, paymentError);
              //loading starts
              razorPayService.getPayment(widget.payableAmount, widget.billing.phone, widget.customerModel.email);
            }
          },
          label: const Text("Confirm Order"),
        ),
      ),
    );
  }
}
