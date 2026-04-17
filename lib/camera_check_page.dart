import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class CameraCheckPage extends StatefulWidget {
  final String type;

  const CameraCheckPage({super.key, required this.type});

  @override
  State<CameraCheckPage> createState() => _CameraCheckPageState();
}

class _CameraCheckPageState extends State<CameraCheckPage> {
  CameraController? _controller;
  List<CameraDescription>? cameras;

  String address = "Loading lokasi...";
  String lat = "-";
  String lng = "-";
  String time = "-";

  @override
  void initState() {
    super.initState();
    initCamera();
    getLocation();
  }

  /// ================= CAMERA =================
  Future<void> initCamera() async {
    cameras = await availableCameras();

    final frontCamera = cameras!.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(frontCamera, ResolutionPreset.medium);

    await _controller!.initialize();
    if (!mounted) return;

    setState(() {});
  }

  /// ================= LOCATION =================
  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition();

    lat = position.latitude.toString();
    lng = position.longitude.toString();
    
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    address = "${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}";

    time = DateFormat('HH:mm').format(DateTime.now());

    setState(() {});
  }

  /// ================= CHECK IN =================
  void doCheckIn() {
    debugPrint("TYPE: ${widget.type}");
    debugPrint("LAT: $lat");
    debugPrint("LNG: $lng");
    debugPrint("ADDRESS: $address");
    debugPrint("TIME: $time");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.type} berhasil")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller == null || !_controller!.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                /// CAMERA VIEW
                CameraPreview(_controller!),

                /// CARD OVERLAY
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.type,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),

                        const SizedBox(height: 8),

                        Text("📍 $address"),
                        Text("Lat: $lat"),
                        Text("Lng: $lng"),
                        Text("⏰ $time"),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: doCheckIn,
                            child: Text(widget.type),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}