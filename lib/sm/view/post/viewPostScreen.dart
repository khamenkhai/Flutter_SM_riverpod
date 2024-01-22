import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/view/commonWidgets/postWidget.dart';

class ViewPostScreen extends ConsumerWidget {
  const ViewPostScreen({super.key,required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            PostWidget(postId: postId)
          ],
        )),
    );
  }
}