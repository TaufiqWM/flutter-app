import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //static const String baseUrl = "http://10.103.1.115/konsol/api";
  static const String baseUrl = "https://konsol.anugrahpratama.com/api";

  /// =========================
  /// LOGIN
  /// =========================
  static Future<bool> login(String username, String password) async {
    try {
      final uri = Uri.parse("$baseUrl/login").replace(
        queryParameters: {
          "user_login": username,
          "user_pass": password,
        },
      );

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        /// ambil token dari response
        String token = data["access_token"] ?? "";
        String nik = data["nik"] ?? "";

        if (token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();

          /// simpan token
          await prefs.setString("token", token);
          await prefs.setString("nik", nik);

          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// =========================
  /// GET TOKEN
  /// =========================
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<String?> getNik() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("nik");
  }

  /// =========================
  /// HEADER AUTH
  /// =========================
  static Future<Map<String, String>> getAuthHeader() async {
    final token = await getToken();

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  /// =========================
  /// LOGOUT
  /// =========================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// =========================
  /// GET (WITH TOKEN)
  /// =========================
  static Future<http.Response> get(String endpoint) async {
    final headers = await getAuthHeader();

    return await http.get(
      Uri.parse("$baseUrl/$endpoint"),
      headers: headers,
    );
  }

  static Future<Map<String, dynamic>> getJson(String endpoint) async {
  final response = await get(endpoint);
  final data = jsonDecode(response.body);

  if (response.statusCode == 200 && data["success"] == true) {
    return data;
  }
  if (response.statusCode == 403) {
    await logout();
    throw Exception("Session expired");
  }
  throw Exception(data["message"] ?? "Error");
}

  /// =========================
  /// POST (WITH TOKEN)
  /// =========================
  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final headers = await getAuthHeader();

    return await http.post(
      Uri.parse("$baseUrl/$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );
  }
}