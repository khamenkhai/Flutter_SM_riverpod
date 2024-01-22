class NotiModel {
  String? notiId;
  String? postId;
  String? userId;
  String? senderId;
  String? senderName;
  String? senderProfile;
  String? notiMessage;
  DateTime? dateTime;

  NotiModel({
    this.notiId,
    this.postId,
    this.userId,
    this.senderId,
    this.senderName,
    this.senderProfile,
    this.notiMessage,
    this.dateTime,
  });

  factory NotiModel.fromMap(Map<String, dynamic> map) {
    return NotiModel(
      notiId: map['notiId'],
      postId: map['postId'],
      userId: map['userId'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      senderProfile: map['senderProfile'],
      notiMessage: map['notiMessage'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notiId': notiId,
      'postId': postId,
      'userId': userId,
      'senderId': senderId,
      'senderName': senderName,
      'senderProfile': senderProfile,
      'notiMessage': notiMessage,
      'dateTime': dateTime?.millisecondsSinceEpoch,
    };
  }



  NotiModel copyWith({
    String? notiId,
    String? postId,
    String? userId,
    String? senderId,
    String? senderName,
    String? senderProfile,
    String? notiMessage,
    DateTime? dateTime,
  }) {
    return NotiModel(
      notiId: notiId ?? this.notiId,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderProfile: senderProfile ?? this.senderProfile,
      notiMessage: notiMessage ?? this.notiMessage,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
