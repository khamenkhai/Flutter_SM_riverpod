
class ReplyModel {
  final String? replyId;
  final String? postId;
  final String? commentId;
  final String? reply;
  final DateTime? time;
  final String? senderName;
  final String? senderProfile;
  final String? senderId;

  ReplyModel({
     this.replyId,
     this.postId,
     this.commentId,
     this.reply,
     this.time,
     this.senderName,
     this.senderProfile,
     this.senderId,
  });

  factory ReplyModel.fromMap(Map<String, dynamic> map) {
    return ReplyModel(
      replyId: map['replyId'],
      postId: map['postId'],
      commentId: map['commentId'],
      reply: map['reply'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      senderName: map['senderName'],
      senderProfile: map['senderProfile'],
      senderId: map['senderId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'replyId': replyId,
      'postId': postId,
      'commentId': commentId,
      'reply': reply,
      'time': time?.millisecondsSinceEpoch,
      'senderName': senderName,
      'senderProfile': senderProfile,
      'senderId': senderId,
    };
  }

  ReplyModel copyWith({
    String? replyId,
    String? postId,
    String? commentId,
    String? reply,
    DateTime? time,
    String? senderName,
    String? senderProfile,
    String? senderId,
    DateTime? date,
  }) {
    return ReplyModel(
      replyId: replyId ?? this.replyId,
      postId: postId ?? this.postId,
      commentId: commentId ?? this.commentId,
      reply: reply ?? this.reply,
      time: time ?? this.time,
      senderName: senderName ?? this.senderName,
      senderProfile: senderProfile ?? this.senderProfile,
      senderId: senderId ?? this.senderId,
    );
  }
}
