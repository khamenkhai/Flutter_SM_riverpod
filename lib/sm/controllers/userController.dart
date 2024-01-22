import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/models/userModel.dart';
import 'package:sm_project/sm/repositories/storageRepo.dart';
import 'package:sm_project/sm/repositories/userRepository.dart';
import 'package:sm_project/sm/utils/utils.dart';

//current user provider
final currentUserProvider = StateProvider<UserModel?>((ref) => null);

//get user data by uid
final getUserByIdController = StreamProvider.family((ref, String uid) =>
    ref.watch(userControllerProvider.notifier).getUser(uid: uid));

//search user by name,with Future data
final searchUserController = StreamProvider.family((ref, String query) =>
    ref.watch(userControllerProvider.notifier).searchUser(query));

//user controllre provider
final userControllerProvider = StateNotifierProvider<UserController, bool>(
    (ref) => UserController(
        userRepository: ref.watch(userRepoController), ref: ref,
        storageRepository: ref.read(storageRepositoryController)
        ));

class UserController extends StateNotifier<bool> {
  final UserRepository userRepository;
  final StorageRepository storageRepository;
  final Ref ref;

  UserController({required this.userRepository, required this.ref,required this.storageRepository})
      : super(false);

  Stream<UserModel> getUser({required String uid}) {
    return userRepository.getUserDataById(uid);
  }

  Future<bool> editUser({String? name,String? bio,Uint8List? imageData,required String uid})async{
    try{
      state = true;
      String profileImg = "";
    if(imageData!=null){
      profileImg = await storageRepository.storeFile(path: 'SMusers/${uid}', imageData: imageData);
    }
    bool status = await userRepository.editUser(uid: uid,bio: bio,name: name,profileImg: profileImg);
    state = false;
    return status;
    }catch(e){
      state = false;
      return false;
    }
  }

  getCurrentUser() async {
    UserModel user = await userRepository.getUserDataById(currentUserId).first;
    ref.watch(currentUserProvider.notifier).update((state) => user);
  }

  //follow a user
  followUser(String targetUserId) {
    userRepository.followUser(
        targetUserId: targetUserId, currentUserId: currentUserId);
  }

  //search user
  Stream<List<UserModel>> searchUser(String query) {
    return userRepository.searchUser(query);
  }
}
