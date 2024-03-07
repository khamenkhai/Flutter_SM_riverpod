import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/models/commentModel.dart';
import 'package:sm_project/sm/models/replyModel.dart';
import 'package:sm_project/sm/utils/consts.dart';
import 'package:sm_project/sm/models/postModel.dart';


///post repository provider to store the data of post repository classs
///by using provider like this. we don't need to crete object instance to use the post repository so it's better for performance and boiler plate code
final postRepoProvider = Provider(
  (ref) => PostRepository(
    firestore: FirebaseFirestore.instance,
    ref: ref,
  ),
);

///post repository
class PostRepository {
  final FirebaseFirestore firestore;
  final Ref ref;

  PostRepository({
    required this.firestore,
    required this.ref,
  });

  CollectionReference get _userCollection =>firestore.collection(Constants.usersCollection);
  CollectionReference get _postCollection =>firestore.collection(Constants.postsCollection);
  CollectionReference get _commentCollection =>firestore.collection(Constants.commentsCollection);
  //CollectionReference get _replyCollection =>firestore.collection(Constants.replyCollection);

  
  /// add new post
  Future<String> addNewPost(PostModel post) async {
    try {
      await _postCollection.doc(post.postId).set(post.toMap());
      return "Post success!";
    } on FirebaseException catch (e) {
      return e.message.toString();
    }
  }

  ///update a post(edit a post);
  Future<bool> updatePost(PostModel post) async {
    try {
      await _postCollection.doc(post.postId).update({
        'postDescription':post.postDescription,
        'feeling':post.feeling
      });
      return true;
    } on FirebaseException catch (e) {
      print(e.message.toString());
      return false;
    }
  }


  ///delete a post
  Future<String> deleteAPost(String postId)async{
    try{
      await _postCollection.doc(postId).delete();
      return "Post deleted success!";
    }on FirebaseException catch(e){
      return e.message.toString();
    }
  }

  //get post of our followings(not all post)
  Stream<List<PostModel>> getFeedPost(){
      return _postCollection.orderBy('date',descending: true).snapshots().map((event) {
      return event.docs
          .map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }


  ///get single post by id
  Stream<PostModel> getPostById(String postId) {
    return _postCollection.doc(postId).snapshots().map((event) {
      return PostModel.fromMap(event.data() as Map<String, dynamic>);
    });
  }


  //like a post
  Future<bool> likeAPost(String postId, String userId) async {
    DocumentSnapshot snapshot = await _postCollection.doc(postId).get();
    if (snapshot["likes"].contains(userId)) {
      await _postCollection.doc(postId).update({
        "likes": FieldValue.arrayRemove([userId])
      });
      return false;
    } else {
      await _postCollection.doc(postId).update({
        "likes": FieldValue.arrayUnion([userId])
      });
      return true;
    }
  }

  ///get user's posts by userId
  Stream<List<PostModel>> getUserPostsByUid(String uid) {
    return _postCollection
        .where("userId", isEqualTo: uid)
        .orderBy("date", descending: true)
        .snapshots()
        .map((event) {
      return event.docs
          .map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }

  ///comment a post
  writeAComment(String commentId, CommentModel comment) async {
    _commentCollection.doc(commentId).set(comment.toMap());

    //increase comment count
    DocumentSnapshot postCollection = await _postCollection.doc(comment.postId).get();

    int commentCount = postCollection["totalComment"];

    await _postCollection
        .doc(comment.postId)
        .update({"totalComment": commentCount + 1});
  }


  ///ediit comment
  Future<bool> editComment(CommentModel comment)async{
    try{
      print("trying");
      if(comment.senderId == FirebaseAuth.instance.currentUser!.uid){
        
       _commentCollection.doc(comment.commentId).update({
        "comment":comment.comment
      });

      print("edited****");
    return true;
    }else{
      print("cant edit***");
      return false;
    }
    }catch(e){
      print("editComment  :  ${e}");
      return false;
    }
  }


  ///delete a comment
  deleteAComment(CommentModel comment)async{
    if(comment.senderId == FirebaseAuth.instance.currentUser!.uid){
      DocumentSnapshot postCollection = await _postCollection.doc(comment.postId).get();
      int commentCount = postCollection["totalComment"];

      await _commentCollection.doc(comment.commentId).delete();

      _postCollection.doc(comment.postId).update({"totalComment" : commentCount - 1});

    }
  }

  //get all comments of a post
  Stream<QuerySnapshot<Object?>> getCommentsOfPost(String postId) {
    return _commentCollection.where("postId", isEqualTo: postId).orderBy("time", descending: true).snapshots();
  }


  //save a post
  savePost({required String postId})async{
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
     DocumentSnapshot snapshot = await _userCollection.doc(currentUserId).get();
    if (snapshot["saved"].contains(postId)) {
      await _userCollection.doc(currentUserId).update({
        "saved": FieldValue.arrayRemove([postId])
      });
      return false;
    } else {
      await _userCollection.doc(currentUserId).update({
        "saved": FieldValue.arrayUnion([postId])
      });
      return true;
    }
  }


  ///make a reply
  makeAReply(ReplyModel reply)async{
      await _commentCollection.doc(reply.commentId).collection(Constants.replyCollection).doc(reply.replyId).set(
        reply.toMap()
      );
  }


  ///get all repliees of a comment
  Stream<List<ReplyModel>> getAllRepliesOfComment(String commentId){
    return _commentCollection.doc(commentId).collection(Constants.replyCollection).orderBy('time',descending: false).snapshots().map((event){
      return event.docs.map((e) => ReplyModel.fromMap(e.data() as Map<String,dynamic>)).toList();
    });
  }



    ///ediit comment
  Future<bool> editAReply(ReplyModel reply)async{
    try{
      print("trying");
      if(reply.senderId == FirebaseAuth.instance.currentUser!.uid){
        
       _commentCollection.doc(reply.commentId).collection(Constants.replyCollection).doc(reply.replyId).update({
        "reply":reply.reply
      });
    return true;
    }else{

      return false;
    }
    }catch(e){
      return false;
    }
  }


  ///delete a comment
  deleteAReply(ReplyModel reply)async{
    if(reply.senderId == FirebaseAuth.instance.currentUser!.uid){
  
      await _commentCollection.doc(reply.commentId).collection(Constants.replyCollection).doc(reply.replyId).delete();

    }
  }
}
