import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:slope_net/Controller/MapLocationController.dart';

class Mapscreen extends StatelessWidget {
  Mapscreen({super.key}) {
    // Controller ready hone par automatic map settings update karne ke liye listener
    ever(locationController.isLcoationReady, (isReady) {
      if (isReady) {
        _updateMapLocationSettings();
      }
    });
  }

  // GetX controller
  final Maplocationcontroller locationController = Get.put(Maplocationcontroller());

  final Rxn<MapboxMap> mapboxMapController = Rxn<MapboxMap>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            onMapCreated: (controller) {
              mapboxMapController.value = controller;
              if (locationController.isLcoationReady.value) {
                _updateMapLocationSettings();
              }
            },
          ),

          Positioned(
            bottom: 40,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.teal,
              child: const Icon(Icons.my_location, color: Colors.white),
              onPressed: () async {
                if (!locationController.isLcoationReady.value) {
                  await locationController.checkRequestPermission();
                }

                if (locationController.isLcoationReady.value) {
                  try {
                    _updateMapLocationSettings();
                    geo.Position position = await geo.Geolocator.getCurrentPosition(
                      desiredAccuracy: geo.LocationAccuracy.high,
                    );
                    mapboxMapController.value?.flyTo(
                      CameraOptions(
                        center: Point(
                          coordinates: Position(position.longitude, position.latitude),
                        ),
                        zoom: 15.0,
                      ),
                      MapAnimationOptions(duration: 1500),
                    );
                  } catch (e) {
                    Get.snackbar("Error", "Could not get current location: $e");
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateMapLocationSettings() {
    if (mapboxMapController.value != null) {
      mapboxMapController.value?.location.updateSettings(
        LocationComponentSettings(
          enabled: true,
          pulsingEnabled: true,
        ),
      );
    }
  }
}