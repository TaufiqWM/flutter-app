import 'package:flutter/material.dart';

class BottomNavGlobal extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onCheckIn;

  const BottomNavGlobal({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(), // biar ada lekukan FAB
      notchMargin: 4,
      child: SizedBox(
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            /// DASHBOARD
            IconButton(
              icon: Icon(
                Icons.home,
                color: currentIndex == 0 ? Colors.blue : Colors.grey,
              ),
              onPressed: () => onTap(0),
            ),
            const SizedBox(width: 20), // space buat FAB
            /// PROFIL
            IconButton(
              icon: Icon(
                Icons.person,
                color: currentIndex == 1 ? Colors.blue : Colors.grey,
              ),
              onPressed: () => onTap(1),
            ),
          ],
        ),
      ),
    );
  }
}

class FABGlobal extends StatelessWidget {
  final VoidCallback onPressed;
  final String status;

  const FABGlobal({super.key, required this.onPressed, required this.status});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: status == "Belum Check In" ?Colors.green : Colors.blue,
      onPressed: onPressed,
      child: Icon(status == "Belum Check In" ? Icons.login : Icons.logout, size: 24),
    );
  }
}
