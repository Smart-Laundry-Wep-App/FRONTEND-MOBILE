import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.field,
    this.errors,
  });

  final String message;
  final int? statusCode;
  final String? field;
  final Map<String, dynamic>? errors;

  @override
  String toString() => message;
}

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();
  static const _tokenKey = 'sca_api_token';
  static const _promoKey = 'sca_applied_promo';
  static const _apiRoot = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5000/api',
  );
  static final Uri _baseUri = Uri.parse(
    _apiRoot.endsWith('/') ? _apiRoot : '$_apiRoot/',
  );
  static const _timeout = Duration(seconds: 15);

  Future<String?> get token async =>
      (await SharedPreferences.getInstance()).getString(_tokenKey);

  Future<bool> get hasSession async => (await token) != null;

  Future<String?> get appliedPromoCode async =>
      (await SharedPreferences.getInstance()).getString(_promoKey);

  Future<void> setAppliedPromoCode(String? code) async {
    final preferences = await SharedPreferences.getInstance();
    if (code == null || code.isEmpty) {
      await preferences.remove(_promoKey);
    } else {
      await preferences.setString(_promoKey, code);
    }
  }

  Future<void> signOut() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_tokenKey);
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String name,
    required String password,
  }) async {
    final result = await _request(
      'POST',
      '/auth/register',
      body: {'email': email, 'name': name, 'password': password},
    );
    await _saveToken(result);
    return _asMap(_asMap(result['data'])['user']);
  }

  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final result = await _request(
      'POST',
      '/auth/login',
      body: {'identifier': identifier, 'password': password},
    );
    await _saveToken(result);
    return _asMap(_asMap(result['data'])['user']);
  }

  Future<void> requestPasswordReset(String email) async {
    await _request('POST', '/auth/forgot-password', body: {'email': email});
  }

  Future<Map<String, dynamic>> signInWithGoogle(String idToken) async {
    final result = await _request(
      'POST',
      '/auth/google',
      body: {'google_token': idToken},
    );
    await _saveToken(result);
    return _asMap(_asMap(result['data'])['user']);
  }

  Future<Map<String, dynamic>> signInWithFacebook(String accessToken) async {
    final result = await _request(
      'POST',
      '/auth/facebook',
      body: {'facebook_token': accessToken},
    );
    await _saveToken(result);
    return _asMap(_asMap(result['data'])['user']);
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    final result = await _request('GET', '/auth/profile', authenticated: true);
    return _asMap(result['data']);
  }

  Future<Map<String, dynamic>> updateProfile(
    Map<String, Object?> profile,
  ) async {
    final result = await _request(
      'PUT',
      '/auth/profile',
      body: profile,
      authenticated: true,
    );
    return _asMap(result['data']);
  }

  Future<Map<String, dynamic>> fetchServices() async {
    final result = await _request('GET', '/services');
    return result;
  }

  Future<Map<String, dynamic>> fetchOperatingHours() async {
    final result = await _request('GET', '/info/operational-hours');
    return _asMap(result['data']);
  }

  Future<Map<String, dynamic>> fetchHelpCenter() async {
    final result = await _request('GET', '/info/help-center');
    return _asMap(result['data']);
  }

  Future<Map<String, dynamic>> fetchPromos() async {
    return _request('GET', '/promos');
  }

  Future<Map<String, dynamic>> validatePromo(
    String code, {
    double orderAmount = 0,
  }) async {
    final result = await _request(
      'POST',
      '/promos/validate',
      body: {'code': code, 'order_amount': orderAmount},
      authenticated: true,
    );
    return _asMap(result['data']);
  }

  Future<Map<String, dynamic>> claimPromo(String code) async {
    return _request(
      'POST',
      '/promos/claim',
      body: {'code': code},
      authenticated: true,
    );
  }

  Future<List<Map<String, dynamic>>> fetchOrders({
    String? status,
    String? month,
  }) async {
    final result = await _request(
      'GET',
      '/orders',
      query: {
        ...?(status != null && status != 'Semua' ? {'status': status} : null),
        ...?(month == null ? null : {'month': month}),
      },
      authenticated: true,
    );
    return _asList(result['data']);
  }

  Future<Map<String, dynamic>?> fetchActiveOrder() async {
    final result = await _request('GET', '/orders/active', authenticated: true);
    return result['data'] == null ? null : _asMap(result['data']);
  }

  Future<Map<String, dynamic>> createOrder(Map<String, Object?> order) async {
    final result = await _request(
      'POST',
      '/orders',
      body: order,
      authenticated: true,
    );
    return _asMap(result['data']);
  }

  Future<Map<String, dynamic>> fetchOrder(String id) async {
    final result = await _request(
      'GET',
      '/orders/${Uri.encodeComponent(id)}',
      authenticated: true,
    );
    return _asMap(result['data']);
  }

  Future<Map<String, dynamic>> createPayment(
    String orderId,
    String paymentMethod,
  ) async {
    final result = await _request(
      'POST',
      '/orders/${Uri.encodeComponent(orderId)}/pay',
      body: {'payment_method': paymentMethod},
      authenticated: true,
    );
    return _asMap(result['data']);
  }

  Future<Map<String, dynamic>> fetchPaymentStatus(String orderId) async {
    final result = await _request(
      'GET',
      '/orders/${Uri.encodeComponent(orderId)}/payment',
      authenticated: true,
    );
    return _asMap(result['data']);
  }

  Future<Map<String, dynamic>> fetchTracking(String orderCode) async {
    final result = await _request(
      'GET',
      '/tracking/${Uri.encodeComponent(orderCode)}',
      authenticated: true,
    );
    return _asMap(result['data']);
  }

  Future<Map<String, dynamic>> fetchNotificationSettings() async {
    final result = await _request('GET', '/auth/profile', authenticated: true);
    final profile = _asMap(result['data']);
    return {
      'notification_settings': _decodeMap(profile['notification_settings']),
      'language': profile['language'] ?? 'Indonesia (INA)',
    };
  }

  Future<Map<String, dynamic>> saveNotificationSettings(
    Map<String, bool> settings,
  ) async {
    final result = await _request(
      'PUT',
      '/auth/notifications',
      body: {'notification_settings': settings},
      authenticated: true,
    );
    return _asMap(result['data']);
  }

  Future<Map<String, dynamic>> sendChatMessage(String message) async {
    final result = await _request(
      'POST',
      '/chatbot/message',
      body: {'message': message},
      authenticated: true,
    );
    return _asMap(result['data']);
  }

  Future<List<Map<String, dynamic>>> fetchChatHistory() async {
    final result = await _request(
      'GET',
      '/chatbot/history',
      authenticated: true,
    );
    return _asList(result['data']);
  }

  Future<void> _saveToken(Map<String, dynamic> result) async {
    final value = _asMap(result['data'])['token'];
    if (value is! String || value.isEmpty) {
      throw const ApiException(
        'Server tidak mengembalikan token login yang valid.',
      );
    }
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_tokenKey, value);
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, Object?>? body,
    Map<String, String>? query,
    bool authenticated = false,
  }) async {
    final uri = _baseUri
        .resolve(path.startsWith('/') ? path.substring(1) : path)
        .replace(queryParameters: {..._baseUri.queryParameters, ...?query});
    final headers = <String, String>{'Accept': 'application/json'};
    if (body != null) headers['Content-Type'] = 'application/json';
    if (authenticated) {
      final savedToken = await token;
      if (savedToken == null) {
        throw const ApiException(
          'Sesi login tidak ditemukan. Silakan masuk kembali.',
          statusCode: 401,
        );
      }
      headers['Authorization'] = 'Bearer $savedToken';
    }

    try {
      final request = http.Request(method, uri)..headers.addAll(headers);
      if (body != null) request.body = jsonEncode(body);
      final streamed = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamed)
          .timeout(_timeout);
      final decoded = response.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException('Format respons server tidak valid.');
      }
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          decoded['success'] == false) {
        final message = decoded['message'] is String
            ? decoded['message'] as String
            : 'Permintaan gagal (${response.statusCode}).';
        final field = decoded['field'] is String ? decoded['field'] as String : null;
        final errors = decoded['errors'] is Map
            ? Map<String, dynamic>.from(decoded['errors'] as Map)
            : null;
        throw ApiException(
          message,
          statusCode: response.statusCode,
          field: field,
          errors: errors,
        );
      }
      return decoded;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('Server terlalu lama merespons. Coba lagi.');
    } on http.ClientException {
      throw const ApiException(
        'Tidak dapat terhubung ke backend. Pastikan server aktif dan API_BASE_URL sesuai.',
      );
    } on FormatException {
      throw const ApiException(
        'Backend mengirim respons yang tidak dapat dibaca.',
      );
    }
  }

  Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _asList(Object? value) {
    if (value is List) {
      return value.whereType<Map>().map(Map<String, dynamic>.from).toList();
    }
    return <Map<String, dynamic>>[];
  }

  Map<String, dynamic> _decodeMap(Object? value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is String && value.isNotEmpty) {
      final decoded = jsonDecode(value);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    }
    return <String, dynamic>{};
  }
}
