import 'package:flutter/material.dart';
import 'package:flutter_myapp/services/auth_service.dart';

class AppBarGlobal extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showNotification;
  final bool showProfileMenu;

  const AppBarGlobal({
    super.key,
    this.title = "MyAbsensi",
    this.showNotification = true,
    this.showProfileMenu = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),

      /// ICON KANAN
      actions: [
        /// NOTIF (opsional)
        if (showNotification)
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Notifikasi diklik")),
              );
            },
          ),

        /// PROFILE MENU (LOGOUT)
        if (showProfileMenu)
        PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'logout') {
              await AuthService.logout();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'logout',
              child: Text("Logout"),
            ),
          ],
          icon: const Icon(Icons.power_settings_new),
        ),
      ],
    );
  }

  /// WAJIB kalau pakai PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}