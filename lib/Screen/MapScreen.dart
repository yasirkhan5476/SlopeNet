import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:slope_net/Controller/MapLocationController.dart';

class Mapscreen extends StatelessWidget {
  Mapscreen({super.key}) {
   
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
      body: MapWidget(
        onMapCreated: (controller) async {
          mapboxMapController.value = controller;
          await _configureMapOrnaments(controller);
          if (locationController.isLcoationReady.value) {
            _updateMapLocationSettings();
          }
        },
      ),
      floatingActionButton:  FloatingActionButton(
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
    );
  }

  Future<void>
  _configureMapOrnaments(MapboxMap controller) async {
    const double bottomClearance = 16.0;
    await controller.logo.updateSettings(
      LogoSettings(
          enabled: false
      ),
    );
    await controller.attribution.updateSettings(
      AttributionSettings(
        enabled: false
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