import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/postController.dart';
import 'package:iconly/iconly.dart';
import 'package:sm_project/sm/models/commentModel.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class CommentScreen extends ConsumerWidget {
  CommentScreen(
      {super.key, required this.postId, required this.postSharerUserId});
  final String postId;
  final String postSharerUserId;

  TextEditingController commentTextController = TextEditingController();

  ///comment a post
  writeAComment(WidgetRef ref, String targetUserId) {
    ref.read(postControllerProvider.notifier).writeAComment(
        postId: postId,
        commentText: commentTextController.text,
        targetUserId: targetUserId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.pop(context);
            }),
        automaticallyImplyLeading: true,
        flexibleSpace: FlexibleSpaceBar(
            background: Column(
          children: [
            Container(),
          ],
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body:

          ///all comments

          ref.watch(getCommentsOfAPostControllerProvider(postId)).when(
        data: (data) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return _commentWidget(data[index], context, () {
                      if (data[index].senderId == currentUserId) {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ///edit comment list tile
                                  ListTile(
                                    onTap: () {},
                                    leading: Icon(IconlyLight.edit),
                                    title: Text("Edit comment"),
                                  ),

                                  ///delete comment list tile
                                  ListTile(
                                    onTap: () {
                                      ref.read(postControllerProvider.notifier).deleteAComment(data[index]);
                                      Navigator.pop(context);
                                    },
                                    leading: Icon(IconlyLight.delete),
                                    title: Text("Delete comment"),
                                  ),
                                ],
                              );
                            });
                      }
                    });
                  },
                ),
              ),

              //comment bar
              Container(
                padding: EdgeInsets.only(left: 15,right: 15,bottom: 7),
                child: TextField(
                  scrollPadding: EdgeInsets.zero,
                  autofocus: true,
                  controller: commentTextController,
                  decoration: InputDecoration(
                    hintText: "Write a comment",
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    suffixIcon: GestureDetector(
                        onTap: () {
                          writeAComment(ref, postSharerUserId);
                          commentTextController.text = "";
                        },
                        child: Icon(IconlyBold.send)),
                    hintStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, s) {
          return errorWidget(s.toString());
        },
        loading: () {
          return Container(
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loadingWidget(color: Colors.black, size: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}

_commentWidget(
    CommentModel comment, BuildContext context, Function() onLongPress) {
  return Container(
    margin: EdgeInsets.only(left: 15, top: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(comment.senderProfile),
        ),
        Container(
          //width: 200,
          margin: EdgeInsets.only(left: 10, bottom: 7),
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 25),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
                topLeft: Radius.circular(20),
              )),
          child: InkWell(
            onLongPress: onLongPress,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${comment.senderName}",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    SizedBox(width: 15),
                    Text("${timeago.format(comment.time)}",
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
                SizedBox(height: 4),
                Text("${comment.comment}", style: TextStyle(fontSize: 12))
              ],
            ),
          ),
        )
      ],
    ),
  );
}
