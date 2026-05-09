class UserModel {
  final String id;
  final String name;
  final String email;
  final String semester;
  final String stream;
  final String avatar;
  final List<dynamic> savedVideos;
  final List<dynamic> likedVideos;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.semester,
    required this.stream,
    required this.avatar,
    this.savedVideos = const [],
    this.likedVideos = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      semester: (json['semester'] ?? '') as String,
      stream: (json['stream'] ?? '') as String,
      avatar: (json['avatar'] ?? '📚') as String,
      savedVideos: List<dynamic>.from(json['savedVideos'] ?? []),
      likedVideos: List<dynamic>.from(json['likedVideos'] ?? []),
    );
  }
}

