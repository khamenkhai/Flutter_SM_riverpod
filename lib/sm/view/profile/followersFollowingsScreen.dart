import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/userController.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:sm_project/sm/view/commonWidgets/followButton.dart';
import 'package:sm_project/sm/view/profile/profileScreen.dart';

class FollowersFollowingsScreen extends ConsumerWidget {
   FollowersFollowingsScreen({super.key, required this.username,required this.userId});
  final String username;
  final String userId;


  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${username}"),
        ),
        body: Column(
          children: [
            TabBar(tabs: [
              Tab(child: Text("followers")),
              Tab(child: Text("following")),
            ]),


            ref.watch(getUserByIdController(userId)).when(data: (user){
              return Expanded(
              child: TabBarView(children: [
                ///for followers
                _followerOrfollowingListWidget(user.followers, ref),
                ///for followings
                _followerOrfollowingListWidget(user.followings, ref),
             
              ]),
            );
            }, 
            
            error: (e,s){
              print("get error in followers and following screen.error at getting followers datas : ${e}");
              return errorWidget(e.toString());
            }, loading: (){
              return loadingWidget();
            })
            
          ],
        ),
      ),
    );
  }

  ListView _followerOrfollowingListWidget(
      List<String> userList, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: userList.length,
      itemBuilder: (context, index) {
        return Container(
          height: 60,
          margin: EdgeInsets.only(right: 15, left: 15),
          child: ref
              .watch(getUserByIdController(userList[index]))
              .when(
                  data: (user) {
                    return GestureDetector(
                      onTap: (){
                        //navigate to user profile
                        navigatorPush(context, ProfileScreen(userId: user.uid));
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.profileImg),
                          ),
                          SizedBox(width: 10),
                          Text("${user.name}"),
                    
                          //follow or unfolow button
                          Spacer(),
                          user.uid == currentUserId ? Container() : 
                          FollowButton(
                              ref: ref,
                              targetUserId: user.uid,
                              width: 99,
                              fontSize: 11),
                        ],
                      ),
                    );
                  },
                  error: (e, s) {
                    print(
                        "got an error in getting the followers of current user ${e}");
                    return Container();
                  },
                  loading: () => Container()),
        );
      },
    );
  }
}
