import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/models/storyModel.dart';
import 'package:sm_project/sm/models/userModel.dart';
import 'package:sm_project/sm/repositories/storageRepo.dart';
import 'package:sm_project/sm/repositories/storyRepository.dart';


//to controller all the related fields with post controller
final storyControllerProvider = StateNotifierProvider<StoryController, bool>(
    (ref) => StoryController(
        storageRepository: ref.watch(storageRepositoryController),
        ref: ref,
        storyRepository: ref.watch(storyRepoProvider)));



// //to get all the posts data as a stream data
final getUserStoriesControllerProvider = StreamProvider.family((ref,String userId) {
  return ref.watch(storyControllerProvider.notifier).getUserStories(userId);
});



///to get all the users who shared stories
final getUsersWhoSharedStoriesControllerProvider = FutureProvider.family((ref,List<String> userIds) {
  return ref.watch(storyControllerProvider.notifier).getUsersWhoSharedStories(userIds);
});



///*****************************main story controller class************************************
class StoryController extends StateNotifier<bool> {
  final StoryRepository storyRepository;
  final StorageRepository storageRepository;
  final Ref ref;

  StoryController(
      {required this.storyRepository,
      required this.ref,
      required this.storageRepository})
      : super(false);

 //create a story
 Future<bool> createStory(Uint8List file,UserModel user)async{
    bool status = await storyRepository.addNewStory(file, user);
    return status;
 }



  //get all stories
  Stream<List<StoryModel>> getUserStories(String userId) {
    return storyRepository.getUserStories(userId);
  }

  //get user who shared stories
  Future<List<UserModel>> getUsersWhoSharedStories(List<String> followingIds){
    return storyRepository.getUsersWhoSharedStories(followingIds);
  }


  
}
