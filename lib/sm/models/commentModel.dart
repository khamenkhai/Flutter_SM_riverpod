
class CommentModel {
  final String commentId;
  final String postId;
  final String comment;
  final DateTime time;
  final String senderName;
  final String senderProfile;
  final String senderId;

  CommentModel({
    required this.commentId,
    required this.postId,
    required this.comment,
    required this.time,
    required this.senderName,
    required this.senderProfile,
    required this.senderId,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'],
      postId: map['postId'],
      comment: map['comment'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      senderName: map['senderName'],
      senderProfile: map['senderProfile'],
      senderId: map['senderId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'postId': postId,
      'comment': comment,
      'time': time.millisecondsSinceEpoch,
      'senderName': senderName,
      'senderProfile': senderProfile,
      'senderId': senderId,
    };
  }

  CommentModel copyWith({
    String? commentId,
    String? postId,
    String? comment,
    DateTime? time,
    String? senderName,
    String? senderProfile,
    String? senderId,
    DateTime? date,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      postId: postId ?? this.postId,
      comment: comment ?? this.comment,
      time: time ?? this.time,
      senderName: senderName ?? this.senderName,
      senderProfile: senderProfile ?? this.senderProfile,
      senderId: senderId ?? this.senderId,
    );
  }
}
