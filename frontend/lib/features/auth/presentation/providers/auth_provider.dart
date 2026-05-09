import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studybyte/core/network/api_client.dart';
import 'package:studybyte/features/auth/data/models/user_model.dart';

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    String semester = '',
    String stream = '',
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.instance.post(
        '/api/auth/signup',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'semester': semester,
          'stream': stream,
        },
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201 && json['success'] == true) {
        final data = json['data'] as Map<String, dynamic>;
        final token = data['token'] as String;
        final userJson = data['user'] as Map<String, dynamic>;
        _user = UserModel.fromJson(userJson);
        await ApiClient.instance.saveToken(token);
      } else {
        throw Exception(json['message'] ?? 'Signup failed');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.instance.post(
        '/api/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 && json['success'] == true) {
        final data = json['data'] as Map<String, dynamic>;
        final token = data['token'] as String;
        final userJson = data['user'] as Map<String, dynamic>;
        _user = UserModel.fromJson(userJson);
        await ApiClient.instance.saveToken(token);
      } else {
        throw Exception(json['message'] ?? 'Login failed');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    await ApiClient.instance.clearToken();
    notifyListeners();
  }
}

