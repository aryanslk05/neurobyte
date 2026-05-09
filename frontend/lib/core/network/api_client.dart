import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient._internal();

  static final ApiClient instance = ApiClient._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Codespaces backend URL - Port 5000
  // Example: https://your-codespace-name-5000.app.github.dev
  static const String baseUrl = 'https://effective-space-disco-v6qr4jv6q9pxhv54-5000.app.github.dev';
  Future<String?> _getToken() async {
    return _storage.read(key: 'jwt');q
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt', value: token);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'jwt');
  }

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    bool authorized = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path');

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (authorized) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return http.post(
      uri,
      headers: headers,
      body: jsonEncode(body ?? {}),
    );
  }

  Future<http.Response> get(
    String path, {
    bool authorized = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path');

    final headers = <String, String>{};

    if (authorized) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return http.get(
      uri,
      headers: headers,
    );
  }

  Future<http.Response> put(
    String path, {
    Map<String, dynamic>? body,
    bool authorized = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path');

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (authorized) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return http.put(
      uri,
      headers: headers,
      body: jsonEncode(body ?? {}),
    );
  }
}