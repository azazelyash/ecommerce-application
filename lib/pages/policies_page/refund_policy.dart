import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:flutter/material.dart';

class RefundPolicy extends StatelessWidget {
  const RefundPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: StandardAppBar(title: "Refund Policy"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Refund Policy",
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
Thank you for your purchase. We regret to inform you that we do not offer refunds on any products. However, we will replace the product with a new one if it is damaged internally.

Please note that we only offer replacements for products that are defective or damaged due to our error. If you receive a product that is damaged during shipping, please contact us within 24 hours of receiving the item, and we will work with you to replace the item.

We do not offer replacements for products that have been damaged due to mishandling or misuse by the customer. In such cases, we reserve the right to deny any replacement requests.

If you have any questions or concerns regarding our no refund policy, please do not hesitate to contact us. We appreciate your business and look forward to serving you in the future.

Exchanges
We only replace items if they are defective or damaged. If you need to exchange it for the same item, email us at support@abhyukthafoods.com  and send your item to: 7-42, MAIN ROAD, Lankapalle, Khammam, Telangana, 507302.

Gifts
If the item was marked as a gift when purchased and shipped directly to you, you’ll receive a gift credit for the value of your return. Once the returned item is received, a gift certificate will be mailed to you.

If the item wasn’t marked as a gift when purchased, or the gift giver had the order shipped to themselves to give to you later, we will send a refund to the gift giver and they will find out about your return.

Shipping Returns
To return your product, you should mail your product to: 7-42, MAIN ROAD, Lankapalle, Khammam, Telangana, 507302

You will be responsible for paying for your own shipping costs for returning your item. Shipping costs are non-refundable. If you receive a refund, the cost of return shipping will be deducted from your refund.

Depending on where you live, the time it may take for your exchanged product to reach you may vary.

If you are returning more expensive items, you may consider using a trackable shipping service or purchasing shipping insurance. We don’t guarantee that we will receive your returned item.

Need help?
Contact us at support@abhyukthafoods.com for questions related to refunds and returns.
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
