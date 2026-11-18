import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

class LanguageService extends ChangeNotifier {
  LanguageService._();
  static final LanguageService instance = LanguageService._();

  static const String _prefKey = 'sca_app_language';
  static const String indonesian = 'Indonesia (INA)';
  static const String english = 'English (US)';

  String _currentLanguage = indonesian;

  String get currentLanguage => _currentLanguage;
  bool get isEnglish => _currentLanguage == english;

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefKey);
      if (saved != null && (saved == english || saved == indonesian)) {
        _currentLanguage = saved;
      }
    } catch (_) {}
  }

  Future<void> setLanguage(String language) async {
    debugPrint('[LanguageService] setLanguage called: $language');
    if (_currentLanguage == language) return;
    _currentLanguage = language;
    debugPrint('[LanguageService] Language updated to: $_currentLanguage');
    notifyListeners();
    debugPrint('[LanguageService] notifyListeners called');
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, language);

      // Sync ke backend jika user sedang login
      if (AuthService.instance.isLoggedIn) {
        await AuthService.instance.updateProfile(language: language);
      }
    } catch (_) {}
  }

  /// Helper fleksibel: jika bahasa Inggris kembalikan [en], jika Indonesia kembalikan [id]
  String t(String id, String en) {
    return isEnglish ? en : id;
  }

  /// Dictionary kata kunci umum
  static String tr(String key) {
    return instance._translate(key);
  }

  String _translate(String key) {
    if (!isEnglish) {
      return _translationsId[key] ?? key;
    }
    return _translationsEn[key] ?? _translationsId[key] ?? key;
  }

  static final Map<String, String> _translationsId = {
    // Nav & Shell
    'nav_login': 'Login',
    'nav_register': 'Register',
    'nav_dashboard': 'Dashboard',
    'nav_services': 'Layanan',
    'nav_hours': 'Jam Kerja',
    'nav_promo': 'Promo',
    'nav_history': 'Riwayat',
    'nav_profile': 'Profil',

    // Bottom Bar
    'bottom_history': 'Riwayat',
    'bottom_services': 'Layanan',
    'bottom_hours': 'Jam Kerja',
    'bottom_profile': 'Profile',

    // Auth - Login
    'login_title': 'SCA Smart Laundry',
    'login_tagline': 'CUCI BERSIH, CEPAT & TEPAT WAKTU',
    'login_welcome': 'Selamat Datang Kembali silahkan Masukan Akun Anda',
    'login_field_identifier': 'EMAIL / USERNAME',
    'login_hint_identifier': 'Masukan email atau username',
    'login_field_password': 'PASSWORD',
    'login_hint_password': 'Masukan kata sandi',
    'login_forgot_password': 'Lupa Password?',
    'login_btn_submit': 'Masuk',
    'login_or': 'Atau Masuk Dengan',
    'login_no_account': 'Belum punya akun?',
    'login_register_now': 'Daftar Sekarang',
    'login_success': 'Login berhasil! Selamat datang,',
    'login_empty_warning': 'Email/Username dan Password wajib diisi.',

    // Auth - Register
    'reg_title': 'Daftar Akun',
    'reg_subtitle': 'Daftar sekarang dan nikmati layanan laundry terbaik',
    'reg_field_name': 'NAMA LENGKAP',
    'reg_hint_name': 'Masukan nama lengkap Anda',
    'reg_field_email': 'EMAIL',
    'reg_hint_email': 'contoh: nama@email.com',
    'reg_field_phone': 'NOMOR TELEPON / WA',
    'reg_hint_phone': 'contoh: 081234567890',
    'reg_field_confirm_pass': 'KONFIRMASI PASSWORD',
    'reg_hint_confirm_pass': 'Ulangi password Anda',
    'reg_btn_submit': 'Daftar Sekarang',
    'reg_has_account': 'Sudah punya akun?',
    'reg_login_now': 'Masuk Sekarang',

    // Profile
    'prof_header': 'Profil Pengguna',
    'prof_edit': 'Edit Profil dan Informasi',
    'prof_notification': 'Kelola Notifikasi',
    'prof_language': 'Bahasa',
    'prof_help': 'Pusat Bantuan',
    'prof_logout': 'Keluar Akun',
    'prof_logout_dialog_title': 'Konfirmasi Keluar',
    'prof_logout_dialog_msg': 'Apakah Anda yakin ingin keluar dari akun SCA Smart Laundry?',
    'prof_logout_cancel': 'Batal',
    'prof_logout_confirm': 'Ya, Keluar',
    'prof_logout_success': 'Anda telah berhasil keluar dari akun.',

    // Edit Profile
    'edit_prof_title': 'Edit Profil',
    'edit_prof_photo_change': 'Ganti Foto Profil',
    'edit_prof_name': 'Nama',
    'edit_prof_username': 'Username',
    'edit_prof_email': 'Email',
    'edit_prof_phone': 'Nomor Telepon',
    'edit_prof_province': 'Provinsi',
    'edit_prof_city': 'Kota atau Kabupaten',
    'edit_prof_address': 'Alamat Lengkap',
    'edit_prof_save': 'Simpan Perubahan',
    'edit_prof_saving': 'Menyimpan...',
    'edit_prof_success': 'Profil berhasil diperbarui.',

    // Dashboard
    'dash_greeting': 'Halo,',
    'dash_welcome': 'Mau laundry apa hari ini?',
    'dash_quick_order': 'Pesan',
    'dash_quick_services': 'Layanan',
    'dash_quick_hours': 'Jam Kerja',
    'dash_quick_promo': 'Promo',
    'dash_active_orders': 'Pesanan Aktif',
    'dash_no_active_orders': 'Belum ada pesanan aktif saat ini.',
    'dash_order_now': 'Pesan Sekarang',
    'dash_order_history': 'Riwayat Terakhir',
    'dash_view_all': 'Lihat Semua',
    'dash_status_washing': 'Sedang Dicuci',
    'dash_status_waiting': 'Menunggu Penjemputan',
    'dash_status_completed': 'Selesai',

    // Info Layanan
    'srv_title': 'Informasi Layanan',
    'srv_back': 'Kembali',
    'srv_price_unit': 'Rp. 10.000 / kg',

    // Jam Operasional
    'hours_title': 'Jam Operasional',
    'hours_open_now': 'Sedang Buka',
    'hours_closed': 'Tutup',
    'hours_desc': 'Kami siap melayani kebutuhan laundry Anda setiap hari dengan kualitas terbaik.',
    'hours_mon_fri': 'Senin - Jumat',
    'hours_sat_sun': 'Sabtu - Minggu',

    // Riwayat
    'hist_title': 'Riwayat Pesanan',
    'hist_tab_active': 'Berlangsung',
    'hist_tab_done': 'Selesai',
    'hist_empty_active': 'Tidak ada pesanan yang sedang berlangsung.',
    'hist_empty_done': 'Belum ada riwayat pesanan yang selesai.',
    'hist_detail': 'Detail Pesanan',
    'hist_track': 'Lacak Posisi Driver',

    // Language Screen
    'lang_title': 'Bahasa',
    'lang_suggested': 'Pilihan Bahasa',

    // Notifications
    'notif_title': 'Notifikasi',
    'notif_general': 'Umum',
    'notif_app_updates': 'Pembaruan Aplikasi',
    'notif_bill_reminder': 'Pengingat Tagihan',
    'notif_promo': 'Penawaran Promo',
    'notif_sound': 'Suara & Getar',
    'notif_save': 'Simpan Pengaturan',

    // Common
    'common_back': 'Kembali',
    'common_cancel': 'Batal',
    'common_save': 'Simpan',
    'common_close': 'Tutup',
    'common_error': 'Terjadi kesalahan',
  };

  static final Map<String, String> _translationsEn = {
    // Nav & Shell
    'nav_login': 'Login',
    'nav_register': 'Register',
    'nav_dashboard': 'Dashboard',
    'nav_services': 'Services',
    'nav_hours': 'Hours',
    'nav_promo': 'Promos',
    'nav_history': 'History',
    'nav_profile': 'Profile',

    // Bottom Bar
    'bottom_history': 'History',
    'bottom_services': 'Services',
    'bottom_hours': 'Hours',
    'bottom_profile': 'Profile',

    // Auth - Login
    'login_title': 'SCA Smart Laundry',
    'login_tagline': 'CLEAN, FAST & ON TIME',
    'login_welcome': 'Welcome Back, please sign in to your account',
    'login_field_identifier': 'EMAIL / USERNAME',
    'login_hint_identifier': 'Enter email or username',
    'login_field_password': 'PASSWORD',
    'login_hint_password': 'Enter your password',
    'login_forgot_password': 'Forgot Password?',
    'login_btn_submit': 'Sign In',
    'login_or': 'Or Sign In With',
    'login_no_account': "Don't have an account?",
    'login_register_now': 'Register Now',
    'login_success': 'Sign in successful! Welcome back,',
    'login_empty_warning': 'Email/Username and Password are required.',

    // Auth - Register
    'reg_title': 'Create Account',
    'reg_subtitle': 'Sign up now and enjoy the best smart laundry experience',
    'reg_field_name': 'FULL NAME',
    'reg_hint_name': 'Enter your full name',
    'reg_field_email': 'EMAIL',
    'reg_hint_email': 'e.g. name@email.com',
    'reg_field_phone': 'PHONE NUMBER / WA',
    'reg_hint_phone': 'e.g. 081234567890',
    'reg_field_confirm_pass': 'CONFIRM PASSWORD',
    'reg_hint_confirm_pass': 'Re-enter your password',
    'reg_btn_submit': 'Register Now',
    'reg_has_account': 'Already have an account?',
    'reg_login_now': 'Sign In Now',

    // Profile
    'prof_header': 'User Profile',
    'prof_edit': 'Edit Profile & Information',
    'prof_notification': 'Manage Notifications',
    'prof_language': 'Language',
    'prof_help': 'Help Center',
    'prof_logout': 'Log Out',
    'prof_logout_dialog_title': 'Log Out Confirmation',
    'prof_logout_dialog_msg': 'Are you sure you want to log out of SCA Smart Laundry?',
    'prof_logout_cancel': 'Cancel',
    'prof_logout_confirm': 'Yes, Log Out',
    'prof_logout_success': 'You have been successfully logged out.',

    // Edit Profile
    'edit_prof_title': 'Edit Profile',
    'edit_prof_photo_change': 'Change Profile Photo',
    'edit_prof_name': 'Name',
    'edit_prof_username': 'Username',
    'edit_prof_email': 'Email',
    'edit_prof_phone': 'Phone Number',
    'edit_prof_province': 'Province',
    'edit_prof_city': 'City / Regency',
    'edit_prof_address': 'Full Address',
    'edit_prof_save': 'Save Changes',
    'edit_prof_saving': 'Saving...',
    'edit_prof_success': 'Profile updated successfully.',

    // Dashboard
    'dash_greeting': 'Hello,',
    'dash_welcome': 'What would you like to wash today?',
    'dash_quick_order': 'Order',
    'dash_quick_services': 'Services',
    'dash_quick_hours': 'Hours',
    'dash_quick_promo': 'Promos',
    'dash_active_orders': 'Active Orders',
    'dash_no_active_orders': 'No active orders at the moment.',
    'dash_order_now': 'Order Now',
    'dash_order_history': 'Recent History',
    'dash_view_all': 'View All',
    'dash_status_washing': 'Washing in Progress',
    'dash_status_waiting': 'Waiting for Pickup',
    'dash_status_completed': 'Completed',

    // Info Layanan
    'srv_title': 'Service Information',
    'srv_back': 'Back',
    'srv_price_unit': 'Rp. 10.000 / kg',

    // Jam Operasional
    'hours_title': 'Operating Hours',
    'hours_open_now': 'Open Now',
    'hours_closed': 'Closed',
    'hours_desc': 'We are ready to serve your laundry needs everyday with the finest quality.',
    'hours_mon_fri': 'Monday - Friday',
    'hours_sat_sun': 'Saturday - Sunday',

    // Riwayat
    'hist_title': 'Order History',
    'hist_tab_active': 'In Progress',
    'hist_tab_done': 'Completed',
    'hist_empty_active': 'No orders currently in progress.',
    'hist_empty_done': 'No completed orders yet.',
    'hist_detail': 'Order Details',
    'hist_track': 'Track Driver Location',

    // Language Screen
    'lang_title': 'Language',
    'lang_suggested': 'Suggested Languages',

    // Notifications
    'notif_title': 'Notifications',
    'notif_general': 'General',
    'notif_app_updates': 'App Updates',
    'notif_bill_reminder': 'Billing Reminders',
    'notif_promo': 'Promo Offers',
    'notif_sound': 'Sound & Vibration',
    'notif_save': 'Save Settings',

    // Common
    'common_back': 'Back',
    'common_cancel': 'Cancel',
    'common_save': 'Save',
    'common_close': 'Close',
    'common_error': 'An error occurred',
  };
}
