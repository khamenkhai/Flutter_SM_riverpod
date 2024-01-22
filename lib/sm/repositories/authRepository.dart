import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/utils/consts.dart';
import 'package:sm_project/sm/models/userModel.dart';
import 'package:sm_project/sm/repositories/storageRepo.dart';

///auth repo controller
final authRepoProvider = Provider((ref) => AuthenticationRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
      firebaseStorage: FirebaseStorage.instance,
      ref: ref
    ));

///main auth repository
class AuthenticationRepository{
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final FirebaseStorage firebaseStorage;
  final Ref ref;

  AuthenticationRepository({
    required this.firestore,
    required this.auth,
    required this.firebaseStorage,
    required this.ref,
  }) ;

  CollectionReference get _userCollection =>
      firestore.collection(Constants.usersCollection);

      Stream<User?> get authStateChanges => auth.authStateChanges();

  //sign out account
  Future<void> signOut()async{
    await auth.signOut();
  }

  //create new account
  Future<String> signup({
    required String email,
    required String password,
    required String name,
    required Uint8List profileFile,
  }) async {

    try{
      UserCredential _userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

     String profileImg = await ref.watch(storageRepositoryController).storeFile(
          path: 'SMusers/${_userCredential.user!.uid}',
          imageData: profileFile,
        );

    if (_userCredential.user != null) {
      UserModel _user = UserModel(
        name: name,
        profileImg: profileImg,
        uid: _userCredential.user!.uid,
        followers: [],
        followings: [],
        posts: [],
        saved: [],
      );
      await _userCollection.doc(_userCredential.user!.uid).set(_user.toMap());

      return "Created account successfully!";
    }

    return "Signup error!!!";

    }on FirebaseAuthException catch(e){
      return e.message.toString();
    }

   

  }

  //login account
  Future<String> login({required String email,required String password})async{
    try{
      UserCredential userCredential= await auth.signInWithEmailAndPassword(email: email, password: password);
      // ignore: unnecessary_null_comparison
      if(userCredential!= null){
        return "Login success!";
      }else{
        return "Login error!";
      }
    }on FirebaseAuthException catch(e){
      return e.message.toString();
    }
  }
}
