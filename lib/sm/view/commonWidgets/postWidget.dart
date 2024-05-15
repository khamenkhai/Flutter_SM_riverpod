import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sm_project/sm/controllers/postController.dart';
import 'package:sm_project/sm/controllers/userController.dart';
import 'package:sm_project/sm/generated/locale_keys.g.dart';
import 'package:sm_project/sm/models/postModel.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:sm_project/sm/view/commonWidgets/myTextWidget.dart';
import 'package:sm_project/sm/view/commonWidgets/shimmerWidget.dart';
import 'package:sm_project/sm/view/home/postImageView.dart';
import 'package:sm_project/sm/view/post/editPostScreen.dart';
import 'package:sm_project/sm/view/profile/profileScreen.dart';
import 'package:sm_project/sm/view/home/commentScreen.dart';
import 'package:sm_project/sm/view/home/peopleWhoReactedScreen.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostWidget extends ConsumerStatefulWidget {
  const PostWidget({super.key, required this.postId});
  final String postId;

  @override
  ConsumerState<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends ConsumerState<PostWidget> {
  ///like a post
  likeAPost(String targetUserId) {
    ref.watch(postControllerProvider.notifier).likeAPost(
          postId: widget.postId,
          targetUserId: targetUserId,
        );
  }

  //delete a post if it's current user's post
  deleteAPost({required BuildContext context}) {
    ref.read(postControllerProvider.notifier).deleteAPost(
          widget.postId,
          context,
        );
  }

  //check if user like the post
  bool checkReaction(PostModel post) {
    if (post.likes.contains(currentUserId)) {
      return true;
    } else {
      return false;
    }
  }

  //check if current user already saved the post
  bool checkSavedPost() {
    return ref.watch(getUserByIdController(currentUserId)).when(
      data: (data) {
        if (data.saved.contains(widget.postId)) {
          return true;
        } else {
          return false;
        }
      },
      error: (e, s) {
        return false;
      },
      loading: () {
        return false;
      },
    );
  }

  //navigate to comment screen
  redirectToCommentScreen(PostModel post, String postOwnerDeliverToken) {
    navigatorPush(
      context,
      CommentScreen(
        postId: post.postId,
        postSharerUserId: post.userId,
        postSharerToken: postOwnerDeliverToken,
      ),
    );
  }

  //save post
  savePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).savePost(widget.postId);
  }

  //navigate to people who liked screen
  navigateToReactsScreen(BuildContext context) {
    navigatorPush(context, PeopleWhoReactedScreen(postId: widget.postId));
  }

  //navigate to user profile screen
  navigateToProfileScreen(BuildContext context, String userId) {
    navigatorPush(
      context,
      ProfileScreen(userId: userId),
      PageTransitionType.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    //print("post widget rebuilding");
    return ref.watch(getPostByIdControllerProvider(widget.postId)).when(
      data: (post) {
        return Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///post header app bar
              _topBarOfPostWidget(context, post),

              //post image
              post.postImage == null || post.postImage == ""
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(left: 45, right: 14, top: 5),
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Stack(
                        children: [
                          ///shimmer
                          ShimmerImageWidget(),

                          //post image
                          InkWell(
                            onTap: () {
                              navigatorPush(
                                context,
                                PostImageView(
                                  imageUrl: post.postImage.toString(),
                                  postId: post.postId,
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  post.postImage.toString(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

              //post description
              post.postDescription != ""
                  ? Container(
                      padding: EdgeInsets.only(left: 45, top: 6, bottom: 1),
                      child: Row(
                        children: [
                          MyTextWidget(
                            text: "${post.postDescription}",
                            color: Theme.of(context).hintColor,
                          ),
                        ],
                      ),
                    )
                  : Container(),

              ///likes and comments
              _postReactionBar(ref, post, context),

              ///total likes and total comments display text
              GestureDetector(
                onTap: () {
                  navigateToReactsScreen(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 55),
                  child: Row(
                    children: [
                      MyTextWidget(
                        text:
                            "${"${post.likes.length}  ${tr(LocaleKeys.lblLikes)}"}",
                        color: Colors.grey,
                        fontSize: 14,
                      ),

                      SizedBox(width: 10),
                      //total comments
                      MyTextWidget(
                        text:
                            "${"${post.totalComment}  ${tr(LocaleKeys.lblComments)}"}",
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Divider(thickness: 0.6),
              ),
            ],
          ),
        );
      },
      error: (error, s) {
        return Container(
          height: MediaQuery.of(context).size.width,
          child: Center(child: Text("This post is not existed anymore!")),
        );
      },
      loading: () {
        return Container(height: 300, child: loadingWidget());
      },
    );
  }

  ///top bar of the post widget that shows user profile image,name,post time,and humburger menu at the right side
  GestureDetector _topBarOfPostWidget(BuildContext context, PostModel post) {
    return GestureDetector(
      onTap: () {
        navigateToProfileScreen(context, post.userId);
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //profile pic
            CircleAvatar(
              backgroundImage: NetworkImage(post.userProfile),
            ),
            SizedBox(width: 10),
            //user name and feeling
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1),
                Row(
                  children: [
                    MyTextWidget(
                      text: "${post.username.capitalizeFirst}",
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    post.feeling != "" ? Text("   -   ") : Container(),
                    MyTextWidget(
                      text: "${post.feeling}",
                      fontSize: 13,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
                SizedBox(height: 3),
                MyTextWidget(
                  text: "${timeago.format(post.date)}",
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ],
            ),

            Spacer(),
            //menu button
            GestureDetector(
              onTap: () {
                //show modal botton sheet
                showBottomSheetOfPost(
                  context,
                  ref: ref,
                  post: post,
                );
              },
              child: Icon(Icons.more_vert),
            )
          ],
        ),
      ),
    );
  }

  //show modal bottom sheet
  showBottomSheetOfPost(
    BuildContext context, {
    required PostModel post,
    required WidgetRef ref,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(),
      ),
      builder: (context) {
        return post.userId == currentUserId
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () {
                      //navigate to edit post
                      navigatorPushReplacement(
                        context,
                        EditPostScreen(post: post),
                      );
                    },
                    leading: Icon(IconlyLight.edit),
                    title: Text("Edit Post"),
                  ),
                  ListTile(
                    onTap: () {
                      //delete post
                      deleteAPost(context: context);
                      Navigator.pop(context);
                    },
                    leading: Icon(IconlyLight.delete),
                    title: Text("Delete Post"),
                  ),
                ],
              )
            : Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      onTap: () {
                        ref
                            .watch(userControllerProvider.notifier)
                            .followUser(post.userId);
                      },
                      leading: Icon(IconlyLight.profile),
                      title:
                          ref.watch(getUserByIdController(currentUserId)).when(
                                data: (data) {
                                  return data.followings.contains(post.userId)
                                      ? Text("Unfollow this user")
                                      : Text("Follow this user");
                                },
                                error: (e, s) => Container(),
                                loading: () => Container(),
                              ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  ///widget that shows buttons to like post,comment post and save post ect..
  Container _postReactionBar(
      WidgetRef ref, PostModel post, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 35),
      child: Row(
        children: [
          SizedBox(width: 10),
          IconButton(
            onPressed: () {
              likeAPost(post.userId);
            },
            icon: checkReaction(post)
                ? Icon(Icons.favorite, color: Colors.red)
                : Icon(Icons.favorite_border),
          ),
          IconButton(
              onPressed: () {
                ref.watch(getUserByIdController(post.userId)).whenData(
                  (value) {
                    return redirectToCommentScreen(post, value.deviceToken!);
                  },
                );
              },
              icon: Icon(LucideIcons.messageCircle)),
          IconButton(onPressed: () {}, icon: Icon(LucideIcons.send)),
          Spacer(),
          IconButton(
            onPressed: () {
              //save post
              savePost(ref);
            },
            icon: checkSavedPost()
                ? Icon(Icons.bookmark)
                : Icon(LucideIcons.bookmark),
          )
        ],
      ),
    );
  }
}
