import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  final double lat;
  final double lng;
  final String type;

  const MapPage({
    super.key,
    required this.lat,
    required this.lng,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    LatLng position = LatLng(lat, lng);

    return Scaffold(
      appBar: AppBar(
        title: Text(type),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: position,
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("current"),
            position: position,
            infoWindow: InfoWindow(title: type),
          ),
        },
      ),
    );
  }
}