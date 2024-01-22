class UserModel {
  final String name;
  final String profileImg;
  final String? deviceToken;
  final String uid;
  final String? bio;
  final List<String> followers;
  final List<String> followings;
  final List<String> posts;
  final List<String> saved;

  UserModel({
    required this.name,
    required this.profileImg,
    this.deviceToken,
    required this.uid,
    this.bio,
    required this.followers,
    required this.followings,
    required this.posts,
    required this.saved,
  });

  // Factory method to create a UserModel from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      profileImg: map['profileImg'],
      uid: map['uid'],
      bio: map['bio'],
      deviceToken: map["deviceToken"],
      followers: List<String>.from(map['followers']),
      followings: List<String>.from(map['followings']),
      posts: List<String>.from(map['posts']),
      saved: List<String>.from(map['saved']),
    );
  }

  // Method to convert a UserModel to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profileImg': profileImg,
      'uid': uid,
      'deviceToken':deviceToken,
      'bio':bio,
      'followers': followers,
      'followings': followings,
      'posts': posts,
      'saved': saved,
    };
  }

  // Method to create a new UserModel with updated values using copyWith
  UserModel copyWith({
    String? name,
    String? profileImg,
    String? coverImg,
    String? uid,
    String? bio,
    List<String>? followers,
    List<String>? followings,
    List<String>? posts,
    List<String>? saved,
  }) {
    return UserModel(
      name: name ?? this.name,
      profileImg: profileImg ?? this.profileImg,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      posts: posts ?? this.posts,
      saved: saved ?? this.saved,
    );
  }
}
