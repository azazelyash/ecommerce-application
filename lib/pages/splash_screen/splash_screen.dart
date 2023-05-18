import 'package:abhyukthafoods/comps/navbar.dart';
import 'package:abhyukthafoods/pages/home/homepage.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacityLevel = 0.0;
  double topLevel = 0.0;
  bool selected = false;

  void initState() {
    super.initState();
    updateUI();
  }

  Future updateUI() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      opacityLevel = 1.0;
      selected = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MainPage(),
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
                      'assets/splash_screen/Abhyuktha Logo.png',
                    ),
                    fit: BoxFit.cover,
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
          AnimatedPositioned(
            bottom: opacityLevel == 1.0 ? 0 : -120,
            left: opacityLevel == 1.0 ? 0 : -120,
            curve: Curves.bounceInOut,
            duration: Duration(milliseconds: 500),
            child: Image(
              image: AssetImage("assets/splash_screen/Splash_Image.png"),
            ),
          ),
        ],
      ),
    );
  }
}
