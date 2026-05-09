import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ThemeMode get themeMode => _themeMode;

  ThemeNotifier() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final value = await _storage.read(key: 'themeMode');
    if (value == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _storage.write(
      key: 'themeMode',
      value: _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }
}

final themeNotifierProvider =
    ChangeNotifierProvider<ThemeNotifier>((ref) => ThemeNotifier());


