import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:flutter/material.dart';

class ReturnPolicy extends StatelessWidget {
  const ReturnPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: StandardAppBar(title: "Return Policy"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Return Policy",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                """
Thank you for your purchase. We take pride in providing high-quality products to our customers. We offer returns only in the event that the product is damaged or faulty.

If you receive a damaged or faulty product, please contact us within 24 hours of receiving the item, and we will work with you to resolve the issue. We will provide a return authorization number , and you can return the product to us within 14 days of receiving the RA.

Please note that we do not accept returns for any other reason, including buyer's remorse or change of mind. Additionally, we cannot accept returns for products that have been damaged due to mishandling or misuse by the customer.

Once we receive the returned product and verify that it meets our return policy, we will issue a refund to the original form of payment within 7-10 business days. Please note that shipping charges are non-refundable.

If you have any questions or concerns regarding our return policy, please do not hesitate to contact us. We appreciate your business and look forward to serving you in the future.
""",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
