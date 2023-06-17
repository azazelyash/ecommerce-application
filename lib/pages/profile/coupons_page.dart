import 'dart:developer';

import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/models/coupon.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:abhyukthafoods/utils/constants.dart';
import 'package:abhyukthafoods/utils/shimmer_containers.dart';
import 'package:flutter/material.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  // Future<List<Coupon>> getCoupons() async {
  //   List<Coupon> coupons = await APIService.listCoupons();

  //   for (var x in coupons) {
  //     log("--------------------");
  //     log("ID : ${x.id}");
  //     log("Amount : ${x.amount}");
  //     log("Code : ${x.code}");
  //     log("Min Amount : ${x.minimumAmount}");
  //     log("dateExpires : ${x.dateExpires}");
  //   }

  //   return coupons;
  // }

  String dateTimeParser(String? data) {
    if (data == null) {
      return "N/A";
    }
    String date = data.substring(0, 10);
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const StandardAppBar(title: "My Coupons"),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: couponPage(),
      ),
    );
  }

  Widget couponPage() {
    return FutureBuilder(
      future: APIService.listCoupons(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Coupon> coupons = snapshot.data as List<Coupon>;
          return ListView.builder(
            itemCount: coupons.length,
            itemBuilder: (context, index) {
              return couponCard(coupons[index]);
            },
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Column(
              children: [
                ShimmerContainer().couponShimmer(),
                const SizedBox(height: 16),
                ShimmerContainer().couponShimmer(),
                const SizedBox(height: 16),
                ShimmerContainer().couponShimmer(),
                const SizedBox(height: 16),
                ShimmerContainer().couponShimmer(),
              ],
            ),
          );
        }
      },
    );
  }

  Widget couponCard(Coupon coupon) {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Code : ",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      coupon.code!,
                      style: TextStyle(
                        fontSize: 16,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "Expires on ${dateTimeParser(coupon.dateExpires)}",
                ),
              ],
            ),
          ),
          Text(
            "₹ ${coupon.amount} Off",
            style: TextStyle(
              fontSize: 16,
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
    // return Card(
    //   margin: const EdgeInsets.all(8),
    //   color: Colors.white,
    //   child: ListTile(
    //     title: Text(coupon.code!),
    //     subtitle: Text("Expires on ${coupon.dateExpires}"),
    //     trailing: Text("₹ ${coupon.amount}"),
    //   ),
    // );
  }
}
