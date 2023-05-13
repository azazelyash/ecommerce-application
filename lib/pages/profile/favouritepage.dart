import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [MyAppbar2(title: "Favourites")],
        ),
      )),
    );
  }
}
