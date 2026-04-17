import 'package:flutter/material.dart';
import 'package:flutter_myapp/widgets/appbar_global.dart';
import 'package:flutter_myapp/widgets/header_global.dart';
import 'package:flutter_myapp/widgets/bottomnav_global.dart';
import 'package:flutter_myapp/services/auth_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
//import 'map_page.dart';
import 'camera_check_page.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? position;
  String currentTime = "";
  String status = "Belum Check In";
  int _currentIndex = 0;
  Map<String, dynamic>? profile;
  String errorMsg = "";

  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      getProfile();
    });
  }

  Future<void> getProfile() async {
  try {
    final nik = await AuthService.getNik();
    final data = await AuthService.getJson("profiledit?nik=$nik");
    debugPrint("HRIS nik: $nik");
    debugPrint("HRIS response: $data");

    setState(() {
      profile = data["data"];
      debugPrint("HRIS profile: $profile");
    });
  } catch (e) {
    setState(() {
      errorMsg = e.toString();
    });
  }
}

  Future<void> getLocation() async {
    try {
      debugPrint("START GET LOCATION");
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      debugPrint("Service Enabled: $serviceEnabled");
      if (!serviceEnabled) {
        debugPrint("GPS MATI");
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint("Permission: $permission");
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        debugPrint("Request Permission: $permission");
      }
      if (permission == LocationPermission.deniedForever) {
        debugPrint("Permission DENIED FOREVER");
        return;
      }
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      debugPrint("LAT: ${pos.latitude}, LNG: ${pos.longitude}");
      setState(() {
        position = pos;
      });
    } catch (e) {
      debugPrint("ERROR LOCATION: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    startClock();
    getProfile();
  }

  void startClock() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      });
    });
  }

  //   void openMap(String type) {
  //   if (position == null) return;
  //   setState(() {
  //     status = type == "CHECK IN"
  //         ? "Sudah Check In"
  //         : "Sudah Check Out";
  //   });

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => MapPage(
  //         lat: position!.latitude,
  //         lng: position!.longitude,
  //         type: type,
  //       ),
  //     ),
  //   );
  // }

  Widget profileCard() {
  debugPrint("Error: $errorMsg");
  return Container(
    width: double.infinity, 
    margin: const EdgeInsets.all(0),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.blue.shade800, Colors.blue.shade500],
      ),
    ),
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?["nama"] ?? "-",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile?["jabatanName"] ?? "-",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Divider(color: Colors.white24, height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoBadge(Icons.location_on, profile?["cabangName"] ?? "-"),
                        _infoBadge(Icons.calendar_today, profile?["tglJoin"] ?? "-"),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 2,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white, // Background transparan estetik
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white30),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: Colors.green.shade700,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/// Widget kecil untuk label lokasi & tanggal
Widget _infoBadge(IconData icon, String label) {
  return Row(
    children: [
      Icon(icon, color: Colors.white70, size: 12),
      const SizedBox(width: 4),
      Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 11),
      ),
    ],
  );
}


  Widget menuCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            menuItem(Icons.history, "Menu 1"),
            menuItem(Icons.approval, "Menu 2"),
            menuItem(Icons.map, "Menu 3"),
            menuItem(Icons.apps, "All Menu"),
          ],
        ),
      ),
    );
  }

  Widget menuItem(IconData icon, String title) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget pengumumanHeader() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Pengumuman Terbaru",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue.shade700,
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            "Lihat Semua",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        )
      ],
    ),
  );
}

Widget pengumumanList() {
  return SizedBox(
    height: 140, // Sedikit lebih tinggi agar teks punya ruang
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 4,
      itemBuilder: (context, index) => _announcementCard(),
    ),
  );
}

Widget _announcementCard() {
  return Container(
    width: 200, // Dibuat lebih lebar agar teks tidak terlalu sesak
    margin: const EdgeInsets.only(right: 12, bottom: 10, top: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade100), 
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          /// Aksen warna di samping (memberi kesan kategori)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 5,
            child: Container(color: Colors.blue.shade400),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.campaign_rounded, color: Colors.blue.shade600, size: 16),
                    const SizedBox(width: 6),
                    const Text(
                      "INFO KANTOR",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Update Pengumuman Absensi Ongoing",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Text(
                  "10 Menit yang lalu",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget dashboardView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const HeaderGlobal(),
        const SizedBox(height: 10),
        profileCard(),
        const SizedBox(height: 10),
        menuCard(),
        const SizedBox(height: 10),
        pengumumanHeader(),
        pengumumanList(),
      ]
    );
  }

  Widget profileView() {
    return ListView(
      children: const [
        SizedBox(height: 200),
        Center(child: Text("Halaman Profil")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarGlobal(title: "Dashboard"),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: _currentIndex == 0 ? dashboardView() : profileView()
      ),
      floatingActionButton: _currentIndex == 0
        ? FABGlobal(
            onPressed: () {
              //openMap(status == "Belum Check In" ? "CHECK IN" : "CHECK OUT");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CameraCheckPage(
                    type: status == "Belum Check In" ? "CHECK IN" : "CHECK OUT",
                  ),
                ),
              );
            },
            status : status
          )
        : null,
      floatingActionButtonLocation: _currentIndex == 0
          ? FloatingActionButtonLocation.centerDocked
          : null,
      bottomNavigationBar: BottomNavGlobal(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        onCheckIn: () {
          //openMap(status == "Belum Check In" ? "CHECK IN" : "CHECK OUT");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CameraCheckPage(
                type: status == "Belum Check In" ? "CHECK IN" : "CHECK OUT",
              ),
            ),
          );
        },
      ),
    );
  }
}