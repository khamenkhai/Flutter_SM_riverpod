import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/models/storyModel.dart';
import 'package:sm_project/sm/models/userModel.dart';
import 'package:sm_project/sm/repositories/storageRepo.dart';
import 'package:sm_project/sm/utils/consts.dart';
import 'package:uuid/uuid.dart';


final storyRepoProvider = Provider(
  (ref) => StoryRepository(
    firestore: FirebaseFirestore.instance,
    storageRepository: ref.read(storageRepositoryController),
    ref: ref,
  ),
);

///post repository
class StoryRepository {
  final FirebaseFirestore firestore;
  final StorageRepository storageRepository;
  final Ref ref;

  StoryRepository({
    required this.firestore,
    required this.ref,
    required this.storageRepository,
  });

  CollectionReference get _userCollection =>
      firestore.collection(Constants.usersCollection);
  CollectionReference get _storyCollection =>
      firestore.collection(Constants.storyCollection);

  ///add new story
  Future<bool> addNewStory(Uint8List file, UserModel user) async {
    try {
      String storyId = Uuid().v4();

      String storyImg = await storageRepository.storeFile(
          path: 'SMstories/${user.uid}/${storyId}',
          imageData: file);

      StoryModel story = StoryModel(
        storyId: storyId,
        likes: [],
        username: user.name,
        userId: user.uid,
        userProfile: user.profileImg,
        createdAt: DateTime.now(),
        storyImg: storyImg,
      );

      _storyCollection.doc(storyId).set(story.toMap());

      return true;
    } catch (e) {
      print("addNewStory : ${e}");
      return false;
    }
  }

  //get all stories
  Stream<List<StoryModel>> getUserStories(String userId) {
    return _storyCollection
        .where(
          'createdAt',
          isGreaterThan: DateTime.now()
              .subtract(const Duration(hours: 24))
              .millisecondsSinceEpoch,
        ).where('userId',isEqualTo: userId)
        .snapshots()
        .map((event) {
      return event.docs
          .map((e) => StoryModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }



Future<List<UserModel>> getUsersWhoSharedStories2(List<String> followingIds) async {

  Set<String> uniqueUserIds = Set<String>();

  List<UserModel> userList = [];

  QuerySnapshot querySnapshot = await _storyCollection.where(
          'createdAt',
          isGreaterThan: DateTime.now()
              .subtract(const Duration(hours: 24))
              .millisecondsSinceEpoch,
        ).get();

  for (DocumentSnapshot document in querySnapshot.docs) {
    StoryModel story = StoryModel.fromMap(document.data() as Map<String, dynamic>);


    if (followingIds.contains(story.userId)) {
      uniqueUserIds.add(FirebaseAuth.instance.currentUser!.uid);
      uniqueUserIds.add(story.userId);
    }
  }


  for (String userId in uniqueUserIds) {

    DocumentSnapshot userSnapshot = await _userCollection.doc(userId).get();

    if (userSnapshot.exists) {
      UserModel user = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
      userList.add(user);
    }
  }

  return userList;
}


Stream<List<UserModel>> getUsersWhoSharedStories(List<String> followingIds) async* {
  Set<String> uniqueUserIds = Set<String>();
  List<UserModel> userList = [];

  final storyQuery = _storyCollection.where(
    'createdAt',
    isGreaterThan: DateTime.now().subtract(const Duration(hours: 24)).millisecondsSinceEpoch,
  );
  
  await for (QuerySnapshot querySnapshot in storyQuery.snapshots()) {
    for (DocumentSnapshot document in querySnapshot.docs) {
      StoryModel story = StoryModel.fromMap(document.data() as Map<String, dynamic>);
      if (followingIds.contains(story.userId)) {
        //uniqueUserIds.add(FirebaseAuth.instance.currentUser!.uid);
        uniqueUserIds.add(story.userId);
        print("story data : ${story} and user id : ${story.userId}");
      }
    }

    for (String userId in uniqueUserIds) {
      DocumentSnapshot userSnapshot = await _userCollection.doc(userId).get();
      if (userSnapshot.exists) {
        UserModel user = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
        userList.add(user);
      }
    }
    print("user list : ${userList}");
    yield userList;
  }
}


// Future<List<UserModel>> getUsersWhoSharedStoriessdfdadfadf(List<String> followingIds) async {
//   Set<String> userIdList = {};
//   List<UserModel> userList = [];

//   // Assuming _storyCollection is your FirebaseFirestore collection reference
//   QuerySnapshot querySnapshot = await _storyCollection.get();

//   for (DocumentSnapshot document in querySnapshot.docs) {
//     StoryModel story = StoryModel.fromMap(document.data() as Map<String, dynamic>);
//     userIdList.clear();

//     // Check if the story's userId is in the list of followingIds
//     if (followingIds.contains(story.userId)) {
//       userIdList.add(story.userId);
//       // Assuming _userCollection is your user collection reference
//       // DocumentSnapshot userSnapshot = await _userCollection.doc(story.userId).get();

//       // if (userSnapshot.exists) {
//       //   UserModel user = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
//       //   userList.add(user);
//       // }
//     }

//     userIdList.forEach((id)async { 
//       DocumentSnapshot userSnapshot = await _userCollection.doc(id).get();
//       if (userSnapshot.exists) {
//         UserModel user = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
//         userList.add(user);
//       }
//     });
//   }

//   return userList;
// }


}
