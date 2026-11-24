import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:slope_net/Component/CustomMapFormfield.dart';
import 'package:slope_net/Component/MetricStatTile.dart';
import 'package:slope_net/Component/RiskBadgePill.dart';
import 'package:slope_net/Component/SlopeSurfaceCard.dart';
import 'package:slope_net/Controller/MapLocationController.dart';
import 'package:slope_net/Utils/AppColors.dart';

class Mapscreen extends StatefulWidget {
  const Mapscreen({super.key});

  @override
  State<Mapscreen> createState() => _MapscreenState();
}

class _MapscreenState extends State<Mapscreen> {
  final Maplocationcontroller locationController = Get.put(
    Maplocationcontroller(),
  );
  final Rxn<MapboxMap> mapboxMapController = Rxn<MapboxMap>();
  Worker? _locationReadyWorker;

  @override
  void initState() {
    super.initState();
    _locationReadyWorker = ever(locationController.isLcoationReady, (isReady) {
      if (isReady) {
        _updateMapLocationSettings();
      }
    });
  }

  @override
  void dispose() {
    _locationReadyWorker?.dispose();
    super.dispose();
  }

  Future<void> _centerOnCurrentLocation() async {
    if (!locationController.isLcoationReady.value) {
      await locationController.checkRequestPermission();
    }

    if (!locationController.isLcoationReady.value) return;

    try {
      _updateMapLocationSettings();
      final geo.Position position = await geo.Geolocator.getCurrentPosition(
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
      Get.snackbar('Error', 'Could not get current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundcolor,
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey('slope_net_home_map'),
            onMapCreated: (controller) async {
              mapboxMapController.value = controller;
              await _configureMapOrnaments(controller);
              if (locationController.isLcoationReady.value) {
                _updateMapLocationSettings();
              }
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Custommapformfield(
                    hinText: 'Where are you heading? e.g., Skardu, Hun...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white54,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SlopeSurfaceCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    backgroundColor:
                    const Color(0xFF2A1416).withValues(alpha: 0.95),
                    borderColor: Colors.redAccent.withValues(alpha: 0.5),
                    onTap: () => Get.toNamed('/alerts'),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.amber),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Landslide warning · Shengus zone',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '3 km ahead · tap for alert details',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.white70),
                      ],
                    ),
                  ),
                    Spacer(),
                  // Action row: SOS + Report Incident on left, My Location on right
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor:   Color(0xFFB91C1C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding:   EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        child:   Text(
                          'SOS',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                        SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon:   Icon(Icons.add, size: 18),
                        label:   Text('Report Incident'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:   Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding:   EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                        Spacer(),
                      FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.teal,
                        onPressed: _centerOnCurrentLocation,
                        child:   Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                    SizedBox(height: 10),
                  SlopeSurfaceCard(
                    backgroundColor:
                    Appcolors.MapScreendowncolor.withValues(alpha: 0.96),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'SHENGUS SECTOR · UPDATED 5M AGO',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10.5,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Jaglot to Skardu · S-1',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.lightBlueAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                          SizedBox(height: 8),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '78',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '/100',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            RiskBadgePill(
                              label: 'High Risk',
                              color: Colors.redAccent,
                              icon: Icons.error_outline,
                            ),
                          ],
                        ),
                          SizedBox(height: 12),
                          Row(
                          children: [
                            Expanded(
                              child: MetricStatTile(
                                title: 'Rainfall',
                                value: '18.4',
                                unit: 'mm/3h',
                                subtitle: 'Rain · Open-Meteo',
                                accentColor: Colors.amber,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: MetricStatTile(
                                title: 'Verified reports',
                                value: '4',
                                subtitle: 'Active alerts',
                                accentColor: Colors.redAccent,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: MetricStatTile(
                                title: 'Next hazard',
                                value: '3 km',
                                subtitle: 'Shengus zone',
                                accentColor: Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _configureMapOrnaments(MapboxMap controller) async {
    await controller.logo.updateSettings(LogoSettings(enabled: false));
    await controller.attribution.updateSettings(
      AttributionSettings(enabled: false),
    );
  }

  void _updateMapLocationSettings() {
    mapboxMapController.value?.location.updateSettings(
      LocationComponentSettings(enabled: true, pulsingEnabled: true),
    );
  }
}