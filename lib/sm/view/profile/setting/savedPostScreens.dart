import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/postController.dart';
import 'package:sm_project/sm/controllers/userController.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:sm_project/sm/view/commonWidgets/postWidget.dart';

class SavedPostScreen extends ConsumerStatefulWidget {
  const SavedPostScreen({super.key});

  @override
  ConsumerState<SavedPostScreen> createState() => _SavedPostScreenState();
}

class _SavedPostScreenState extends ConsumerState<SavedPostScreen> {


   //save post
  saveOrRemovePost(String postId){
    ref.read(postControllerProvider.notifier).savePost(postId);
  }
  
  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(title: Text("Saved")),

      body: ref.watch(getUserByIdController(currentUserId)).when(data: (data){
        return ListView.builder(
          itemCount: data.saved.length,
          itemBuilder: (context,index){
            return PostWidget(postId: data.saved[index]);
        });
      }, error: (error,s){
        return errorWidget(error.toString());
      }, loading: (){
        return loadingWidget();
      }),
    );
  }
}