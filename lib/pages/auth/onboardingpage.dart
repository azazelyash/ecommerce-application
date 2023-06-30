import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/pages/auth/login_using_firebase.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'loginpage.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final CarouselController _controller = CarouselController();
  int _currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: CarouselSlider(
                        items: [
                          OB1(onNextPressed: () {
                            _controller.nextPage();
                          }),
                          OB2(),
                        ],
                        options: CarouselOptions(
                          height: constraints.maxHeight,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: false,
                          reverse: false,
                          autoPlay: false,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, _) {
                            setState(() {
                              _currentSlide = index;
                            });
                          },
                        ),
                        carouselController: _controller,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: constraints.maxHeight * 0.062,
                  left: constraints.maxWidth * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      2, // Replace '2' with the number of slides
                      (index) => buildDotIndicator(index),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildDotIndicator(int index) {
    return Container(
      width: 20.0,
      height: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        shape: _currentSlide == index ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: _currentSlide == index ? BorderRadius.circular(4.0) : null,
        color: _currentSlide == index ? Colors.green.shade900 : Colors.grey,
      ),
    );
  }
}

class OB1 extends StatelessWidget {
  final VoidCallback onNextPressed;

  const OB1({Key? key, required this.onNextPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Image.asset("assets/Login-signup/OB1.png"),
              ),
              Text(
                "Discover a vast selection of culinary delights with our comprehensive catalogue.",
                style: GoogleFonts.dmSans(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.w700,
                ),
                textScaleFactor: 1.0,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                "We've curated a selection of pickles that are made using regional recipes and techniques.",
                style: GoogleFonts.dmSans(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w300,
                ),
                textScaleFactor: 1.0,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: MediaQuery.of(context).size.width * 0.02),
              GestureDetector(
                onTap: onNextPressed,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.green.shade900,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Text(
                      "Next",
                      style: GoogleFonts.dmSans(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textScaleFactor: 1.0,
                    ),
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

class OB2 extends StatelessWidget {
  const OB2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Image.asset("assets/Login-signup/OB2.png"),
              ),
              Text(
                "Discover a vast selection of culinary delights with our comprehensive catalogue.",
                style: GoogleFonts.dmSans(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.w700,
                ),
                textScaleFactor: 1.0,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                "We've curated a selection of pickles that are made using regional recipes and techniques.",
                style: GoogleFonts.dmSans(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w300,
                ),
                textScaleFactor: 1.0,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.02,
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => LoginUsingFirebase(),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.green.shade900,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Text(
                      "Continue",
                      style: GoogleFonts.dmSans(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textScaleFactor: 1.0,
                    ),
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
