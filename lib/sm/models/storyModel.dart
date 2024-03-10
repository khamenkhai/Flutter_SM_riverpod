class StoryModel {
  final String? storyId;
  final List<String>? likes;
  final String? username;
  final String? userId;
  final String? userProfile;
  final DateTime? createdAt;
  final String? storyImg;

  StoryModel({
    this.storyId,
    this.likes,
    this.username,
    this.userId,
    this.userProfile,
    this.createdAt,
    this.storyImg
  });

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      storyId: map['storyId'],
      likes: List<String>.from(map['likes']),
      username: map['username'],
      userId: map['userId'],
      userProfile: map['userProfile'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      storyImg: map['storyImg']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storyId': storyId,
      'likes': likes,
      'username': username,
      'userId': userId,
      'userProfile': userProfile,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'storyImg':storyImg
    };
  }
}
