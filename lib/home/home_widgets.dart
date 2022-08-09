import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:get/get.dart';
import 'package:location_notificator_app/home/home_controller.dart';
import 'package:latlong2/latlong.dart';

class FAT extends StatelessWidget {
  FAT({
    Key? key,
  }) : super(key: key);

  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: (() {
        homeController.isFixed.value = !homeController.isFixed.value;
      }),
      child: Obx(() => Icon(
            Icons.gps_fixed,
            color: homeController.isFixed.value
                ? Colors.greenAccent
                : Colors.redAccent,
          )),
    );
  }
}

class HomeMap extends StatelessWidget {
  HomeMap({
    Key? key,
  }) : super(key: key);

  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => FlutterMap(
          mapController: homeController.mapController,
          options: MapOptions(
            onTap:
                homeController.isMarkerAdded ? null : homeController.addMarker,
            center: LatLng(
                homeController.latitude.value, homeController.longitude.value),
            zoom: 18.0,
            maxZoom: 19.0,
          ),
          children: [
            TileLayerWidget(options: mapTileLayerOptions()),
            MarkerLayerWidget(options: locationMarkLayerOptions()),
            PopupMarkerLayerWidget(options: mapMarkerLayerOptions())
          ],
        ));
  }

  MarkerLayerOptions locationMarkLayerOptions([double deviceMarkerSize = 20]) {
    return MarkerLayerOptions(markers: [
      Marker(
          width: deviceMarkerSize,
          height: deviceMarkerSize,
          point: LatLng(
              homeController.latitude.value, homeController.longitude.value),
          builder: (ctx) => Material(
                elevation: 3,
                borderRadius:
                    BorderRadius.all(Radius.circular(deviceMarkerSize)),
                child: Icon(
                  Icons.circle,
                  size: deviceMarkerSize,
                  color: Colors.blueAccent,
                ),
              ))
    ]);
  }

  PopupMarkerLayerOptions mapMarkerLayerOptions() {
    return PopupMarkerLayerOptions(
        popupController: homeController.popupLayerController,
        markerRotateAlignment:
            PopupMarkerLayerOptions.rotationAlignmentFor(AnchorAlign.top),
        popupBuilder: (BuildContext context, Marker marker) => PopUp(),
        markers: homeController.markers.toList());
  }

  TileLayerOptions mapTileLayerOptions() {
    return TileLayerOptions(
        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        userAgentPackageName: 'clinic.example.app',
        subdomains: ['a', 'b', 'c']);
  }
}

class PopUp extends StatelessWidget {
  PopUp({Key? key}) : super(key: key);
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 10),
          child: Icon(Icons.location_on),
        ),
        _cardDescription(context),
        IconButton(
            onPressed: () {
              homeController.deleteMarker();
            },
            icon: const Icon(Icons.close)),
      ]),
    );
  }

  Widget _cardDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Text(
              'Your Destination',
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
            Text(
              'This is your destination!',
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
