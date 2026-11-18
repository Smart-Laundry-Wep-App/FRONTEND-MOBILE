import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static const String _prefKeyBaseUrl = 'sca_backend_base_url';

  // Default fallback URL based on active platform
  static String get defaultBaseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:5000/api';
    }
    try {
      if (Platform.isAndroid) {
        // 10.0.2.2 is the special alias to host localhost in Android Emulator
        return 'http://10.0.2.2:5000/api';
      }
    } catch (_) {}
    return 'http://127.0.0.1:5000/api';
  }

  static String _baseUrl = defaultBaseUrl;

  static String get baseUrl => _baseUrl;

  /// Inisialisasi konfigurasi saat aplikasi mulai
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKeyBaseUrl);
    if (saved != null && saved.trim().isNotEmpty) {
      _baseUrl = saved.trim();
    } else {
      _baseUrl = defaultBaseUrl;
    }
  }

  /// Memperbarui baseUrl (misal ke IP Wi-Fi PC saat testing di HP fisik)
  static Future<void> setBaseUrl(String newUrl) async {
    _baseUrl = newUrl.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKeyBaseUrl, _baseUrl);
  }

  /// Reset ke default
  static Future<void> resetBaseUrl() async {
    _baseUrl = defaultBaseUrl;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKeyBaseUrl);
  }
}
