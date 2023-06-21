import 'package:abhyukthafoods/comps/appbar.dart';
import 'package:abhyukthafoods/services/location.dart';
import 'package:flutter/material.dart';
import 'package:map/map.dart';

class GPSLocationPage extends StatefulWidget {
  const GPSLocationPage({super.key});

  @override
  State<GPSLocationPage> createState() => _GPSLocationPageState();
}

class _GPSLocationPageState extends State<GPSLocationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  void getLocation() async {
    await Location().getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(title: "GPS Location"),
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Hello"),
      ),
    );
  }
}
