import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/postController.dart';
import 'package:sm_project/sm/models/commentModel.dart';
import 'package:sm_project/sm/models/replyModel.dart';

class EditCommentScreen extends ConsumerStatefulWidget {
  const EditCommentScreen({super.key, this.comment,this.reply});
  final CommentModel? comment;
  final ReplyModel? reply;

  @override
  ConsumerState<EditCommentScreen> createState() => _EditCommentScreenState();
}

class _EditCommentScreenState extends ConsumerState<EditCommentScreen> {
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    if(widget.comment!=null){
      _commentController.text = widget.comment!.comment;
    }else if(widget.reply!=null){
      _commentController.text = widget.reply!.reply!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Comment"),
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: Size(1, 1),
            child: ref.watch(postControllerProvider) ? LinearProgressIndicator() : Divider(
              color: Colors.grey.shade600,
              thickness: 0.1,
            ) 
            ),
      ),
      body: SafeArea(
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.comment!=null ? widget.comment!.senderProfile : widget.reply!.senderProfile!),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      contentPadding:
                          EdgeInsets.only(bottom: 0, top: 0, left: 10),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ))
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.only(right: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      )
                    ),
                  ),
                  SizedBox(width: 13),
                  ElevatedButton(
                    onPressed: ()async {
                      if(widget.comment!=null){
                        bool status = await ref.read(postControllerProvider.notifier).editAComment(widget.comment!.copyWith(comment: _commentController.text));
                      if(status){
                        Navigator.pop(context);
                      } 
                      }else{
                        bool status = await ref.read(postControllerProvider.notifier).editAReply(widget.reply!.copyWith(reply: _commentController.text));
                      if(status){
                        Navigator.pop(context);
                      } 
                      }
                    },
                    child: Text("Save"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      )
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
