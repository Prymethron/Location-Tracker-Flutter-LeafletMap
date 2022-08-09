import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/extension_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import '../main.dart';

class HomeController extends GetxController {
  RxDouble longitude = 0.0.obs;
  RxDouble latitude = 0.0.obs;
  final RxList<Marker> markers = <Marker>[].obs;
  final MapController mapController = MapController();
  final Location location = Location();
  late StreamSubscription locationTracker;
  bool isMarkerAdded = false;
  RxBool isFixed = true.obs;
  final PopupController popupLayerController = PopupController();

  @override
  void onInit() {
    super.onInit();
    trackLocation();
  }

  void trackLocation() async {
    location.enableBackgroundMode(enable: true);
    locationTracker = location.onLocationChanged.listen((response) {
      syncLocation(response);
    });
  }

  void syncLocation(LocationData response) {
    var newLongitude = response.longitude;
    var newLatitude = response.latitude;
    if (newLongitude != null && newLatitude != null) {
      longitude.value = newLongitude;
      latitude.value = newLatitude;
      if (isFixed.value) {
        mapController.move(
            LatLng(latitude.value, longitude.value), mapController.zoom);
      }
      if (markers.isNotEmpty) {
        if (markers[0].point.latitude <= latitude.value + 0.0002 &&
            markers[0].point.latitude >= latitude.value - 0.0002 &&
            markers[0].point.longitude <= longitude.value + 0.0002 &&
            markers[0].point.longitude >= longitude.value - 0.0002) {
          deleteMarker();
          sendNotification();
        }
      }
    }
  }

  void addMarker(tapPosition, point) {
    markers.add(Marker(
      rotate: true,
      point: point,
      builder: (context) => const Icon(Icons.location_on),
    ));
    isMarkerAdded = true;
  }

  void deleteMarker() {
    isMarkerAdded = false;
    markers.removeAt(0);
    popupLayerController.hideAllPopups();
  }

  void sendNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Map App',
      'You have reached to location!',
      platformChannelSpecifics,
    );
  }
}
