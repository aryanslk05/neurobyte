class VideoTimelineItem {
  final String id;
  final String title;
  final String topic;
  final String subTopic;
  final String videoUrl;
  final String thumbnailUrl;
  final int orderNumber;

  VideoTimelineItem({
    required this.id,
    required this.title,
    required this.topic,
    required this.subTopic,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.orderNumber,
  });

  factory VideoTimelineItem.fromJson(Map<String, dynamic> json) {
    return VideoTimelineItem(
      id: (json['_id'] ?? json['id'])?.toString() ?? '',
      title: json['title'] as String,
      topic: json['topic'] as String,
      subTopic: json['subTopic'] as String,
      videoUrl: json['videoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      orderNumber: json['orderNumber'] as int,
    );
  }
}

class QuizItem {
  final String id;
  final String subTopic;
  final int afterVideoNumber;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  QuizItem({
    required this.id,
    required this.subTopic,
    required this.afterVideoNumber,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });

  factory QuizItem.fromJson(Map<String, dynamic> json) {
    return QuizItem(
      id: json['_id'] as String,
      subTopic: json['subTopic'] as String,
      afterVideoNumber: json['afterVideoNumber'] as int,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List<dynamic>),
      correctAnswerIndex: json['correctAnswerIndex'] as int,
      explanation: (json['explanation'] ?? '') as String,
    );
  }
}

enum TimelineType { video, quiz }

class TimelineEntry {
  final TimelineType type;
  final VideoTimelineItem? video;
  final QuizItem? quiz;

  TimelineEntry.video(this.video)
      : type = TimelineType.video,
        quiz = null;

  TimelineEntry.quiz(this.quiz)
      : type = TimelineType.quiz,
        video = null;
}

