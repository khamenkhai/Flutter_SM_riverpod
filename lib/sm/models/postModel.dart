class PostModel {
  final String postId;
  String? postDescription;
  String? postImage;
  final List<String> likes;
  final String username;
  final String userId;
  final String userProfile;
  final DateTime date;
  final int totalComment;
  String? feeling;

  PostModel({
    required this.postId,
    this.postDescription,
    this.postImage,
    required this.likes,
    required this.username,
    required this.userId,
    required this.userProfile,
    required this.date,
    required this.totalComment,
    required this.feeling,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'],
      postDescription: map['postDescription'],
      postImage: map['postImage'],
      likes: List<String>.from(map['likes']),
      username: map['username'],
      userId: map['userId'],
      userProfile: map['userProfile'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      totalComment: map['totalComment'],
      feeling: map['feeling'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'postDescription': postDescription,
      'postImage': postImage,
      'likes': likes,
      'username': username,
      'userId': userId,
      'userProfile': userProfile,
      'date': date.millisecondsSinceEpoch,
      'totalComment': totalComment,
      'feeling': feeling,
    };
  }

  PostModel copyWith({
    String? postId,
    String? postDescription,
    String? postImage,
    List<String>? likes,
    String? username,
    String? userId,
    String? userProfile,
    DateTime? date,
    int? totalComment,
    String? feeling,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      postDescription: postDescription ?? this.postDescription,
      postImage: postImage ?? this.postImage,
      likes: likes ?? this.likes,
      username: username ?? this.username,
      userId: userId ?? this.userId,
      userProfile: userProfile ?? this.userProfile,
      date: date ?? this.date,
      totalComment: totalComment ?? this.totalComment,
      feeling: feeling ?? this.feeling,
    );
  }
}
