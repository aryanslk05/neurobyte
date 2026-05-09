import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studybyte/core/network/api_client.dart';
import 'package:studybyte/features/auth/data/models/user_model.dart';
import 'package:studybyte/features/auth/presentation/providers/auth_provider.dart';
import 'package:studybyte/features/home/data/models/video_timeline_item.dart';

final userProvider = ChangeNotifierProvider<UserNotifier>((ref) {
  return UserNotifier(ref);
});

class UserNotifier extends ChangeNotifier {
  UserNotifier(this._ref);

  final Ref _ref;

  List<VideoTimelineItem> _savedVideos = [];
  List<String> _savedIds = [];
  List<String> _likedIds = [];
  Map<String, dynamic> _stats = {};
  Map<String, dynamic> _subTopicProgress = {};
  bool _isLoading = false;

  List<VideoTimelineItem> get savedVideos => _savedVideos;
  List<String> get savedIds => _savedIds;
  List<String> get likedIds => _likedIds;
  Map<String, dynamic> get stats => _stats;
  Map<String, dynamic> get subTopicProgress => _subTopicProgress;
  bool get isLoading => _isLoading;

  bool isSaved(String videoId) => _savedIds.contains(videoId);
  bool isLiked(String videoId) => _likedIds.contains(videoId);

  Future<void> loadSavedVideos() async {
    if (!_ref.read(authProvider).isLoggedIn) return;
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await ApiClient.instance.get('/api/user/saved', authorized: true);
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 && json['success'] == true) {
        final data = json['data'] as Map<String, dynamic>;
        final raw = data['videos'] as List<dynamic>? ?? [];
        _savedVideos = raw
            .map((v) => VideoTimelineItem.fromJson(v as Map<String, dynamic>))
            .toList();
        _savedIds = _savedVideos.map((v) => v.id).toList();
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadProfileStats() async {
    if (!_ref.read(authProvider).isLoggedIn) return;
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await ApiClient.instance.get('/api/user/stats', authorized: true);
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 && json['success'] == true) {
        final data = json['data'] as Map<String, dynamic>;
        final userJson = data['user'] as Map<String, dynamic>?;
        if (userJson != null) {
          final u = UserModel.fromJson(userJson);
          _ref.read(authProvider).setUser(u);
          _savedIds = u.savedVideos.map((v) => v.toString()).toList();
          _likedIds = u.likedVideos.map((v) => v.toString()).toList();
        }
        _stats = data['stats'] as Map<String, dynamic>? ?? {};
        _subTopicProgress =
            data['subTopicProgress'] as Map<String, dynamic>? ?? {};
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleSave(String videoId) async {
    if (!_ref.read(authProvider).isLoggedIn) return;
    try {
      final response = await ApiClient.instance.post(
        '/api/user/save/$videoId',
        authorized: true,
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 && json['success'] == true) {
        final data = json['data'] as Map<String, dynamic>;
        final raw = data['savedVideos'] as List<dynamic>? ?? [];
        _savedIds = raw.map((v) => v.toString()).toList();
        await loadSavedVideos();
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> toggleLike(String videoId) async {
    if (!_ref.read(authProvider).isLoggedIn) return;
    try {
      final response = await ApiClient.instance.post(
        '/api/user/like/$videoId',
        authorized: true,
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 && json['success'] == true) {
        final data = json['data'] as Map<String, dynamic>;
        final raw = data['likedVideos'] as List<dynamic>? ?? [];
        _likedIds = raw.map((v) => v.toString()).toList();
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> syncFromAuth() async {
    final auth = _ref.read(authProvider);
    if (auth.user != null) {
      await loadProfileStats();
      _savedIds = (auth.user!.savedVideos as List<dynamic>?)
              ?.map((v) => v.toString())
              .toList() ??
          [];
      _likedIds = (auth.user!.likedVideos as List<dynamic>?)
              ?.map((v) => v.toString())
              .toList() ??
          [];
      notifyListeners();
    }
  }

  void setSavedLikedFromAuth(UserModel? user) {
    if (user == null) {
      _savedIds = [];
      _likedIds = [];
    } else {
      _savedIds = user.savedVideos.map((v) => v.toString()).toList();
      _likedIds = user.likedVideos.map((v) => v.toString()).toList();
    }
    notifyListeners();
  }
}
