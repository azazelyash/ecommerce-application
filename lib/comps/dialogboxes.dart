import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDialogBox extends StatelessWidget {
  final String content;
  final VoidCallback yes;
  const MyDialogBox({
    super.key,
    required this.content,
    required this.yes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      height: 165,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1.0,
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              content,
              style:
                  GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w700),
              textScaleFactor: 1.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.dmSans(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                    textScaleFactor: 1.0,
                  ),
                ),
                GestureDetector(
                  onTap: yes,
                  child: Container(
                    width: 110,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Yes",
                        style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MyAlertDialog extends StatelessWidget {
  final String content;
  final VoidCallback yes;

  const MyAlertDialog({
    Key? key,
    required this.content,
    required this.yes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 175,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.shade100,
            //     blurRadius: 0.1,
            //   ),
            // ]
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        content,
                        style: GoogleFonts.dmSans(
                            fontSize: 15, fontWeight: FontWeight.w700),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.dmSans(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                          textScaleFactor: 1.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: yes,
                        child: Container(
                          width: 95,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Yes",
                              style: GoogleFonts.dmSans(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                              textScaleFactor: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
