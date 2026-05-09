import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:studybyte/core/network/api_client.dart';
import 'package:studybyte/features/home/data/models/video_timeline_item.dart';

final videoTimelineProvider =
    ChangeNotifierProvider<VideoTimelineNotifier>((ref) {
  return VideoTimelineNotifier();
});

class VideoTimelineNotifier extends ChangeNotifier {
  final Map<String, List<TimelineEntry>> _timelines = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<TimelineEntry> timelineFor(String subTopic) =>
      _timelines[subTopic] ?? [];

  Future<void> loadForSubTopic(String subTopic) async {
    if (_timelines.containsKey(subTopic) && _timelines[subTopic]!.isNotEmpty) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final Response response = await ApiClient.instance
          .get('/api/videos/$subTopic', authorized: true);
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200 || json['success'] != true) {
        throw Exception(json['message'] ?? 'Failed to load videos');
      }

      final data = json['data'] as Map<String, dynamic>;
      final List<dynamic> rawTimeline = data['timeline'] as List<dynamic>;

      final entries = <TimelineEntry>[];
      for (final item in rawTimeline) {
        final map = item as Map<String, dynamic>;
        if (map['type'] == 'video') {
          entries.add(
            TimelineEntry.video(
              VideoTimelineItem.fromJson(
                map['video'] as Map<String, dynamic>,
              ),
            ),
          );
        } else if (map['type'] == 'quiz') {
          entries.add(
            TimelineEntry.quiz(
              QuizItem.fromJson(
                map['quiz'] as Map<String, dynamic>,
              ),
            ),
          );
        }
      }

      _timelines[subTopic] = entries;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

