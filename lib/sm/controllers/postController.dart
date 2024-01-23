import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/notiController.dart';
import 'package:sm_project/sm/controllers/userController.dart';
import 'package:sm_project/sm/models/commentModel.dart';
import 'package:sm_project/sm/models/notiModel.dart';
import 'package:sm_project/sm/models/postModel.dart';
import 'package:sm_project/sm/models/userModel.dart';
import 'package:sm_project/sm/repositories/postRepository.dart';
import 'package:sm_project/sm/repositories/storageRepo.dart';
import 'package:sm_project/sm/services/notificationService.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:uuid/uuid.dart';

//to controller all the related fields with post controller
final postControllerProvider = StateNotifierProvider<PostController, bool>(
    (ref) => PostController(
      notificationsService:   NotificationsService(),
        storageRepository: ref.read(storageRepositoryController),
        ref: ref,
        postRepository: ref.read(postRepoProvider)));

//to get all the posts data as a stream data
final getFeedPostsControllerProvider = StreamProvider<List<PostModel>>((ref) {
  //return ref.watch(postRepoProvider).getFeedPost();
  return ref.read(postRepoProvider).getFeedPost();
});

///to get a single post data by it's id
final getPostByIdControllerProvider =
    StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getPostById(postId);
});

///too get user's all posts by use's uid
final getUserPostsByUidControllerProvider =
    StreamProvider.family((ref, String uid) {
  return ref.read(postControllerProvider.notifier).getUserPostsByUid(uid);
});

///to get all comments of a post as list of stream data
final getCommentsOfAPostControllerProvider =
    StreamProvider.family((ref, String postId) {
  return ref.read(postControllerProvider.notifier).getCommentsOfAPost(postId);
});

///*****************************main post controller class************************************
class PostController extends StateNotifier<bool> {
  final PostRepository postRepository;
  final StorageRepository storageRepository;
  final Ref ref;
  final NotificationsService notificationsService;

  PostController(
      {required this.postRepository,
      required this.ref,
      required this.notificationsService,
      required this.storageRepository})
      : super(false);

  //post image or text on firebase
  addNewPost({
    Uint8List? postImage,
    String? postDescription,
    String? feeling,
    required BuildContext context,
  }) async {
    state = true;
    String postId = Uuid().v4();
    final user = ref.read(currentUserProvider);
    String? imageUrl;

    if (postImage != null) {
      imageUrl = await storageRepository.storeFile(
        path: 'SMposts/${postId}',
        imageData: postImage,
      );
    }

    PostModel post = PostModel(
      postId: postId,
      postDescription: postDescription,
      likes: [],
      username: user!.name,
      userId: user.uid,
      postImage: imageUrl,
      userProfile: user.profileImg,
      date: DateTime.now(),
      totalComment: 0,
      feeling: feeling,
    );

    await postRepository.addNewPost(post);

    state = false;
    showMessageSnackBar(message: "Post success!", context: context);

    state = false;

    ///go ack to main page
    Navigator.pop(context);
  }


  //update post
  updatePost({required PostModel post, required BuildContext context}) async {

    state = true;

    bool status = await postRepository.updatePost(post);

    showMessageSnackBar(message: "Post update success!", context: context);

    Future.delayed(Duration(seconds: 1)).then((value) => state = false);

    state = false;

    status ? Navigator.pop(context) : null;
  }


  //get all the post
  Stream<List<PostModel>> getFeedPosts() {
    return postRepository.getFeedPost();
  }


  //get post by is
  Stream<PostModel> getPostById(String postId) {
    return postRepository.getPostById(postId);
  }


  ///delete a post
  deleteAPost(String postId, BuildContext context) async {
    await postRepository.deleteAPost(postId);
    showMessageSnackBar(message: "Delete a post", context: context);
  }


  //like a post
  likeAPost({required String postId, required String targetUserId}) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    bool isLike = await postRepository.likeAPost(postId, currentUserId);
    if (isLike && (currentUserId != targetUserId)) {
      // ref.read(notiControllerProvider).sendANotiMessage(
      //   // sender: user,postId: postId, notiMessage: "like your post", targetUserId: targetUserId,
      //   noti: NotiModel(
      //       notiId: notiId,
      //       dateTime: DateTime.now(),
      //       notiMessage: "comment on your post",
      //       userId: targetUserId,
      //       postId: postId,
      //       senderId: currentUserId,
      //       senderName: currentUser.name,
      //       senderProfile: currentUser.profileImg,
      //     ),
      //   );
    }
  }


  ///get user's post by userId
  Stream<List<PostModel>> getUserPostsByUid(String uid) {
    return postRepository.getUserPostsByUid(uid);
  }



  ///write a comment to a post
  writeAComment(
      {required String postId,
      required String commentText,
      required String targetUserId,
      required String targetUserToken, 
      }) async {
    //final user = ref.read(currentUserProvider);
  UserModel? currentUser;

    ref.read(getUserByIdController(currentUserId)).whenData((value){
      currentUser = value;
    });

    if(currentUser!=null){
      String commentId = Uuid().v4();
    String notiId = Uuid().v4();
    CommentModel comment = CommentModel(
      commentId: commentId,
      postId: postId,
      comment: commentText,
      time: DateTime.now(),
      senderName: currentUser!.name,
      senderProfile: currentUser!.profileImg,
      senderId: currentUser!.uid,
    );

    await postRepository.writeAComment(commentId, comment);

    if (currentUser!.uid != targetUserId) {
      // sender: user,postId: postId, notiMessage: "comment on your post", targetUserId: targetUserId
      ref.read(notiControllerProvider).sendANotiMessage(
              noti: NotiModel(
            notiId: notiId,
            dateTime: DateTime.now(),
            notiMessage: "comment on your post",
            userId: targetUserId,
            postId: postId,
            senderId: currentUser?.uid,
            senderName: currentUser!.name,
            senderProfile: currentUser!.profileImg,
          ),
        );

        //test noti

        await notificationsService.sendNotification(postId: postId,body: "body", senderId: currentUserId, receiverTokenId: targetUserToken);
    }
    }

    await notificationsService.sendNotification(postId: postId,body: "${currentUser!.name} comment on your post!", senderId: currentUserId, receiverTokenId: targetUserToken);
  }

  //delete a comment
  deleteAComment(CommentModel comment) {
    postRepository.deleteAComment(comment);
  }

  //get all comments of a post
  Stream<List<CommentModel>> getCommentsOfAPost(String postId) {
    return postRepository.getCommentsOfPost(postId).map((event) {
      return event.docs
          .map((e) => CommentModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }

  //save post
  savePost(String postId) {
    postRepository.savePost(postId: postId);
  }

}
