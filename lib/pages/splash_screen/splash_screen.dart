import 'dart:convert';
import 'dart:developer';

import 'package:abhyukthafoods/comps/navbar.dart';
import 'package:abhyukthafoods/models/cart.dart';
import 'package:abhyukthafoods/models/customer.dart';
import 'package:abhyukthafoods/models/shipping.dart';
import 'package:abhyukthafoods/pages/auth/onboardingpage.dart';
import 'package:abhyukthafoods/services/api_services.dart';
import 'package:abhyukthafoods/services/shared_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget defaultPage = const OnboardingPage();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacityLevel = 0.0;
  double topLevel = 0.0;
  bool selected = false;
  CustomerModel? customerModel;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    getCustomerData();
    getCartDetials();
    shippingDetails();
    updateUI();
  }

  void shippingDetails() async {
    minimumOrderForFreeDelivery = await APIService().freeShippingEligiblility();
    shippingCharges = await APIService().shippingCharge();
  }

  Future<void> getCartDetials() async {
    cartItems = await SharedService.cartDetails();
    Cart().updateCartLength();
  }

  Future<void> getCustomerData() async {
    customerModel = await SharedService.customerDetails();
    /* -------------------------- print customer model -------------------------- */
    log("Customer Model: ${customerModel!.toJson()}");
  }

  /* ---------------------- Function To Create Animation ---------------------- */

  // This Function is used to create animation for the splash screen,
  // it will wait for 500 milliseconds and then it will change the opacity of the logo and the image to 1.0
  // and then it will wait for another 500 milliseconds and then it will check if the user is logged in or not,
  // if the user is logged in then it will redirect the user to the home page
  // else it will redirect the user to the onboarding page.

  Future updateUI() async {
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      opacityLevel = 1.0;
      selected = true;
    });
    bool result = await SharedService.isLoggedIn();

    if (result) {
      defaultPage = MainPage(
        customerModel: customerModel!,
      );
    }
    await Future.delayed(const Duration(milliseconds: 1000));

    nextPage();
  }

  void nextPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => defaultPage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: const AssetImage(
              'assets/splash_screen/Splash_Background.png',
            ),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                curve: Curves.easeIn,
                opacity: opacityLevel,
                duration: const Duration(milliseconds: 500),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage(
                          'assets/app_logo/logo.png',
                        ),
                        fit: BoxFit.cover,
                        height: 150,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "India's largest Pickles store",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36.0),
                        child: Text(
                          "Abhyukta Foods is a reliable and reputed site where you can order pickles online and also can get your desired items at your home only. You don’t need to go anywhere as it is available online.",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: const LinearProgressIndicator(),
              ),
            ],
          ),
          AnimatedPositioned(
            bottom: opacityLevel == 1.0 ? 0 : -120,
            left: opacityLevel == 1.0 ? 0 : -120,
            curve: Curves.bounceInOut,
            duration: const Duration(milliseconds: 500),
            child: const Image(
              image: AssetImage("assets/splash_screen/Splash_Image.png"),
            ),
          ),
        ],
      ),
    );
  }
}
