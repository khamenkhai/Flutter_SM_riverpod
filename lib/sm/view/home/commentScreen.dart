import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/postController.dart';
import 'package:iconly/iconly.dart';
import 'package:sm_project/sm/controllers/userController.dart';
import 'package:sm_project/sm/models/commentModel.dart';
import 'package:sm_project/sm/models/replyModel.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:sm_project/sm/view/home/editCommentScreen.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class CommentScreen extends ConsumerStatefulWidget {
  CommentScreen({
    super.key,
    required this.postId,
    required this.postSharerUserId,
    required this.postSharerToken,
  });
  final String postId;
  final String postSharerUserId;
  final String postSharerToken;

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  TextEditingController commentTextController = TextEditingController();

  ///comment a post
  writeAComment(
      {required WidgetRef ref,
      required String targetUserId,
      required String targetUserToken}) {
    ref.read(postControllerProvider.notifier).writeAComment(
        targetUserToken: targetUserToken,
        postId: widget.postId,
        commentText: commentTextController.text,
        targetUserId: targetUserId);
  }

  ///reply a comment
  replyAComment() {
    if (replyingCommentId != "" || replyingCommentId.isNotEmpty) {
      ref.watch(getUserByIdController(currentUserId)).whenData((value) {
        ref.read(postControllerProvider.notifier).makeAReply(
            commentId: replyingCommentId,
            reply: commentTextController.text,
            senderName: value.name,
            senderProfile: value.profileImg,
            senderId: value.uid);
      });
    }
  }

  int? replyingIndex = null;
  String replyingCommentId = "";
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
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
          ref.watch(getCommentsOfAPostControllerProvider(widget.postId)).when(
        data: (data) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return _commentWidget(
                      isReplying:
                          replyingIndex == index && replyingIndex != null,
                      comment: data[index],
                      context: context,
                      ref: ref,
                      onReply: () {
                        setState(() {
                          if (replyingIndex == index) {
                            replyingIndex = null;
                          } else {
                            replyingIndex = index;
                            _focusNode.requestFocus();
                          }
                          replyingCommentId = data[index].commentId;
                          print(replyingCommentId);
                        });
                      },
                      // onLongPress: () {
                      //   if (data[index].senderId == currentUserId) {
                      //     _commentEditOrDeleteModal(context: context,comment:  data[index]);
                      //   }
                      // }
                    );
                  },
                ),
              ),

              //comment bar
              Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 7, top: 5),
                child: TextField(
                  focusNode: _focusNode,
                  scrollPadding: EdgeInsets.zero,
                  autofocus: true,
                  controller: commentTextController,
                  decoration: InputDecoration(
                    hintText: replyingIndex != null
                        ? "Reply a comment..."
                        : "Write a comment...",
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    suffixIcon: GestureDetector(
                        onTap: () {
                          if (replyingIndex != null) {
                            replyAComment();
                          } else {
                            writeAComment(
                                ref: ref,
                                targetUserId: widget.postSharerUserId,
                                targetUserToken: widget.postSharerToken);
                          }

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

  Future<dynamic> _commentEditOrDeleteModal({
    required BuildContext context,
     CommentModel? comment,
     ReplyModel? reply,
    required bool isReply
  }) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///edit comment list tile
              ListTile(
                onTap: () {
                  if(!isReply && comment!=null){
                    navigatorPush(context, EditCommentScreen(comment: comment));
                  }else if(isReply && reply!=null){
                    navigatorPush(context, EditCommentScreen(reply: reply));
                  }
                },
                leading: Icon(IconlyLight.edit),
                title: Text(!isReply && comment!=null ? "Edit comment":"Edit reply"),
              ),

              ///delete comment list tile
              ListTile(
                onTap: () {
                  if(!isReply && comment!=null){
                     ref
                      .read(postControllerProvider.notifier)
                      .deleteAComment(comment);
                  }else if(isReply && reply!=null){
                     ref
                      .read(postControllerProvider.notifier)
                      .deleteAReply(reply);
                  }
                 
                  Navigator.pop(context);
                },
                leading: Icon(IconlyLight.delete),
                title: Text(!isReply && comment!=null ? "Delete comment":"Delete reply"),
              ),
            ],
          );
        });
  }

  _commentWidget(
      {required CommentModel comment,
      required WidgetRef ref,
      required BuildContext context,
      required bool isReplying,
      // required Function() onLongPress,
      required Function() onReply}) {
    return Container(
      margin: EdgeInsets.only(left: 15, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///user circle
              CircleAvatar(
                backgroundImage: NetworkImage(comment.senderProfile),
              ),

              ///comment field
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    //width: 200,
                    margin: EdgeInsets.only(left: 10, bottom: 1),
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 25),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(20),
                        )),
                    child: InkWell(
                      onLongPress: () {
                        ///is commenting
                        if (comment.senderId == currentUserId) {
                          _commentEditOrDeleteModal(
                            context: context,
                            comment: comment,
                            isReply: false
                          );
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${comment.senderName}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              SizedBox(width: 15),
                              Text("${timeago.format(comment.time)}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600)),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text("${comment.comment}",
                              style: TextStyle(fontSize: 12))
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: onReply,
                      child: Text(isReplying ? "Cancel" : "Reply")),
                ],
              )
            ],
          ),

          SizedBox(height: 10),

          ref
              .watch(getRepliesOfCommentControllerProvider(comment.commentId))
              .when(
                  data: (data) {
                    return Container(
                      margin: EdgeInsets.only(left: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data.map((reply) {
                          ///reply widget
                          return _replyWidget(reply, context);
                        }).toList(),
                      ),
                    );
                  },
                  error: (e, s) {
                    return Text(s.toString());
                  },
                  loading: () => Container()),
          SizedBox(height: 1),
        ],
      ),
    );
  }

  Container _replyWidget(ReplyModel reply, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          ///user circle
          CircleAvatar(
            backgroundImage: NetworkImage(reply.senderProfile!),
          ),
          InkWell(
            onLongPress: (){
              _commentEditOrDeleteModal(
                            context: context,
                            reply: reply,
                            isReply: true
                          );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 2, left: 15),
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 7, top: 7),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${reply.senderName}",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(width: 15),
                      Text("${timeago.format(reply.time!)}",
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text("${reply.reply}", style: TextStyle(fontSize: 12))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
