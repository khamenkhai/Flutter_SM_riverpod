import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/utils/consts.dart';
import 'package:sm_project/sm/models/userModel.dart';

///user repo controller
final userRepoController = Provider((ref) => UserRepository(
    firestore: FirebaseFirestore.instance,
    firebaseStorage: FirebaseStorage.instance,
    ref: ref));

///main auth repository
class UserRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  final Ref ref;

  UserRepository({
    required this.firestore,
    required this.firebaseStorage,
    required this.ref,
  });

  CollectionReference get _userCollection =>
      firestore.collection(Constants.usersCollection);


  //get user data by id
  Stream<UserModel> getUserDataById(String uid) {
    return _userCollection.doc(uid).snapshots().map((event) {
      return UserModel.fromMap(event.data() as Map<String, dynamic>);
    });
  }



  Future<bool> editUser({String? name,String? bio,String? profileImg,required String uid})async{

   try{
     Map<String, dynamic> userInformation = Map();

    if (name != "" && name != null) userInformation['name'] = name;

    if (bio != "" && bio != null) userInformation['bio'] = bio;

    if (profileImg != "" && profileImg != null) userInformation['profileImg'] = profileImg;


    await _userCollection.doc(uid).update(userInformation);
    return true;
   }catch(e){
    return false;
   }
  }



  //follow a user
  Future followUser(
      {required String targetUserId, required String currentUserId}) async {
    DocumentSnapshot snapshot = await _userCollection.doc(targetUserId).get();
    //if the target user is already followed unfollow
    //if not follow again
    if (snapshot["followers"].contains(currentUserId)) {
      await _userCollection.doc(targetUserId).update({
        "followers": FieldValue.arrayRemove([currentUserId])
      });
      await _userCollection.doc(currentUserId).update({
        "followings": FieldValue.arrayRemove([targetUserId])
      });
    } else {
      await _userCollection.doc(targetUserId).update({
        "followers": FieldValue.arrayUnion([currentUserId])
      });
      await _userCollection.doc(currentUserId).update({
        "followings": FieldValue.arrayUnion([targetUserId])
      });
    }
  }

  //search user
  Stream<List<UserModel>> searchUser(String query) {
    return _userCollection
        .snapshots()
        .map((event) => event.docs
            .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
            .where((element){
              final name = element.name.toLowerCase();
              final input = query.toLowerCase();
              if(name == "" || name.isEmpty){}
              return name.contains(input);
            }).toList()
            
            );
  }
}

