import 'dart:developer';
import 'dart:ffi';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  double? latitude;
  double? longitude;

  LocationService({this.latitude, this.longitude});

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    latitude = position.latitude;
    longitude = position.longitude;

    log("Latitude: $latitude");
    log("Longitude: $longitude");
    return position;
  }

  Future<List<Placemark>> getCurrentAddress(double latitude, double longitude) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    // for (int i = 0; i < placemarks.length; i++) {
    //   log("<-----------------Placemark----------------->");
    //   log("Placemark $i: ${placemarks[i].toJson()}");
    // }

    return placemarks;
  }

  Future<Placemark> fillAddressFields() async {
    Position position = await getCurrentLocation();
    List<Placemark> placemarks = await getCurrentAddress(position.latitude, position.longitude);

    log("Placemarks: ${placemarks[0]}");

    return placemarks[0];
  }
}
