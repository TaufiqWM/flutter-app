import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderGlobal extends StatelessWidget {
  const HeaderGlobal({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return "Selamat Pagi";
    if (hour < 18) return "Selamat Siang";
    return "Selamat Malam";
  }

  String getDate() {
    return DateFormat('dd MMMM yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${getGreeting()}, ${getDate()}",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}