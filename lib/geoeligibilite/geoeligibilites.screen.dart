import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';


class GeoEligibiliteScreen extends StatelessWidget {
  const GeoEligibiliteScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return FlutterMap(
    options: MapOptions(
        center: LatLng(16.1922065, -61.27238249999999),
        zoom: 8.5,
    ),
    nonRotatedChildren: [
        AttributionWidget.defaultWidget(
            source: 'OpenStreetMap contributors',
            onSourceTapped: null,
        ),
    ],
    children: [
        TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
        ),
    ],
);
  }
}