import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [StandardAppBar(title: "Favourites")],
        ),
      )),
    );
  }
}
