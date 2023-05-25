import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum PaymentMethod { COD, RazorPay }

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? _paymentMethod = PaymentMethod.COD;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          onPressed: () {},
          label: const Text("Confirm Order"),
        ),
      ),
    );
  }
}
