import 'package:flutter/material.dart';
import 'package:flutter_myapp/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  void login(BuildContext context) async {
  debugPrint("HRIS LOGIN DIKLIK");
  debugPrint("HRIS username : ${username.text}");
  debugPrint("HRIS password : ${password.text}");

  if (username.text.isEmpty || password.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Username & Password wajib diisi"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    return;
  }
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    bool success = await AuthService.login(
      username.text,
      password.text,
    );
    final nik = await AuthService.getNik();
    debugPrint("HRIS success : $success");
    debugPrint("HRIS NIK : $nik");

    if (!context.mounted) return;
    Navigator.pop(context);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Login Berhasil"),
          backgroundColor: Colors.greenAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Login gagal"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  } catch (e) {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.white10),

          // 3. Konten Utama
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  // Logo atau Icon pendukung
                  const Icon(Icons.lock_person_rounded, size: 80, color: Colors.white),
                  const SizedBox(height: 10),
                  const Text(
                    "Selamat Datang",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Text(
                    "Masuk untuk melanjutkan absensi",
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),

                  // Input Email /Nik
                  _buildTextField(
                    controller: username,
                    label: "Email / Nik",
                    icon: Icons.person_2_outlined
                  ),
                  const SizedBox(height: 20),

                  // Input Password
                  _buildTextField(
                    controller: password,
                    label: "Password",
                    isPassword: true,
                    icon: Icons.lock_outline
                  ),
                  const SizedBox(height: 30),

                  // Button Login
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () => login(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black54),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54), 
        prefixIcon: Icon(icon, color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.white12, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
