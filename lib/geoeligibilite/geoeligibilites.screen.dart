import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';


class GeoEligibiliteScreen extends StatelessWidget {
  const GeoEligibiliteScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return FlutterMap(
    options: const MapOptions(
        center: LatLng(16.1922065, -61.27238249999999),
        zoom: 8.5,
    ),
    children: [
        TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
        ),
    ],
);
  }
}