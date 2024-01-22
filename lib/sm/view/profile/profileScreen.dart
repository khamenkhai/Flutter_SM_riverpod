import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sm_project/sm/controllers/authController.dart';
import 'package:sm_project/sm/controllers/postController.dart';
import 'package:sm_project/sm/controllers/userController.dart';
import 'package:sm_project/sm/generated/locale_keys.g.dart';
import 'package:sm_project/sm/models/userModel.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:sm_project/sm/view/commonWidgets/followButton.dart';
import 'package:sm_project/sm/view/commonWidgets/postWidget.dart';
import 'package:sm_project/sm/view/profile/editProfileScreen.dart';
import 'package:sm_project/sm/view/profile/followersFollowingsScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sm_project/sm/view/profile/setting/languageScreen.dart';
import 'package:sm_project/sm/view/profile/setting/savedPostScreens.dart';
import 'package:sm_project/sm/view/profile/setting/themeScreen.dart';
import 'package:sm_project/sm/view/post/viewPostScreen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  ProfileScreen({required this.userId});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  bool viewImages = false;

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = FirebaseAuth.instance.currentUser!.uid == widget.userId;

    

    return ref.watch(getUserByIdController(widget.userId)).when(data: (user) {
      return SafeArea(
        
        child: Scaffold(
          appBar: _profileAppBar(user: user,context:  context,isCurrentUser:  isCurrentUser,ref:  ref),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildProfileHeader(user),
                              _profileStats(user,context),
                            ],
                          ),
                  
                          //follow button or edit button
                          isCurrentUser
                              ? Container(
                                  margin: EdgeInsets.only(top: 20, left: 10),
                                  width: 130,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //navigate to eidt user screen
                                      navigatorPush(context, EditProfileScreen());
                                    },
                                    child: Text("${tr(LocaleKeys.lblEdit)}"),
                                    style: ElevatedButton.styleFrom(elevation: 0),
                                  ),
                                )
                              :
                              //follow or unfollow button
                              Container(
                                margin: EdgeInsets.only(left: 15,top: 15),
                                child: FollowButton(ref: ref,targetUserId: user.uid))
                        ],
                      ),
                    ),
            
                _profileBodyWidget(user, isCurrentUser, ref),
               
              ],
            ),
          ),
        ),
      );
    }, error: (error, s) {
      return errorWidget(error.toString());
    }, loading: () {
      return Container(
        height: 650,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loadingWidget(color: Colors.black, size: 50),
          ],
        ),
      );
    });
  }

  //profile top form widget 
  AppBar _profileAppBar({required UserModel user,required BuildContext context,required bool isCurrentUser,required WidgetRef ref}) {
    return AppBar(
                title: Text(user.name),
                actions: [

                  isCurrentUser ?
                  IconButton(onPressed: () {
                    ///show setting modal botton
                    showModalBottomSheet(context: context, builder: (context){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            onTap: (){
                              
                              ///navigate to save posts screen
                              navigatorPushReplacement(context, SavedPostScreen());
                            },
                            leading: Icon(IconlyLight.bookmark),
                            title: Text(tr(LocaleKeys.lblBookmarks)),
                          ),
                          ListTile(
                            onTap: (){
                              ///navigate to theme screen
                              navigatorPushReplacement(context, ThemeScreen());
                              
                            },
                            leading: Icon(IconlyLight.image),
                            title: Text(tr(LocaleKeys.lblTheme)),
                          ),
                          ListTile(
                            onTap: () {

                            navigatorPushReplacement(context, LanguageScreen(),PageTransitionType.rightToLeft);
                          },
                            leading: Icon(Icons.language),
                            title: Text(tr(LocaleKeys.lblLanguage)),
                          ),

                          ListTile(
                        onTap: (){
                          Navigator.pop(context);
                          showDialog(context: context, builder: (context){
                            return _logoutDialog(ref, context);
                          });
                        },
                        leading: Icon(IconlyBold.logout),
                        title: Text("${tr(LocaleKeys.lblLogout)}"),
                      ),
                        ],
                      );
                    });
                  }, icon: Icon(IconlyLight.setting)) : Container(),
                ],
              
              
              );
  }

  //logout dialog
  AlertDialog _logoutDialog(WidgetRef ref, BuildContext context) {
    return AlertDialog(
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                content: Column(  
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                      child: Text("Are you sure to log out?",style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold))),
                    Divider(height: 0),
                    ListTile(
                      onTap: (){
                        Navigator.pop(context);
                        ref.read(authControllerProvider.notifier).signOut(context);
                        
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Logout"),
                        ],
                      ),
                    ),
                    Divider(height: 0),
                    ListTile(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Cancel"),
                        ],
                      ),
                    ),
                  ],
                ),
              );
  }

  SingleChildScrollView _profileBodyWidget(
      UserModel user, bool isCurrentUser, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        


          SizedBox(height: 25),
            Row(
                children: [
                  ///add photo tab bar
                  Expanded(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            viewImages = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(bottom:15),
                          child: Center(child: Icon(viewImages == false ? IconlyBold.activity: IconlyLight.activity)),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: viewImages == false ? 2.5 : 0,
                                color:  viewImages == false ? Theme.of(context).primaryColor : Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      )),
                  ///detail info tab bar
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          viewImages = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom:15),
                        child: Center(child: Icon(viewImages ? IconlyBold.image :IconlyLight.image)),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(
                            width: viewImages? 2.5 : 0,
                            color:  viewImages ? Theme.of(context).primaryColor : Colors.transparent,
                          )
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          

          SizedBox(height: 20),

          viewImages == false ? 
          //user's posts
          ref.watch(getUserPostsByUidControllerProvider(widget.userId)).when(
            data: (data) {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return PostWidget(
                    postId: data[index].postId,
  
                  );
                },
              );
            },
            error: (error, s) {
              return Column(
                children: [
                  Text(error.toString()),
                  Text(s.toString()),
                ],
              );
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
          ) :  
          //view images,
          ref.watch(getUserPostsByUidControllerProvider(widget.userId)).when(
            data: (data) {
              var imageDatas = data.where((post) => post.postImage != null).toList();
              return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: imageDatas.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10
                ),
                padding: EdgeInsets.only(left: 15,right: 15),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      //navigate to view posts
                      navigatorPush(context, ViewPostScreen(postId: imageDatas[index].postId));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(imageDatas[index].postImage!,fit: BoxFit.cover)),
                  );
                },
              );
            },
            error: (error, s) {
              return Column(
                children: [
                  Text(error.toString()),
                  Text(s.toString()),
                ],
              );
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
          )
        ],
      ),
    );
  }
}


///profle header widget
Widget _buildProfileHeader(UserModel user) {
  return Padding(
    padding: const EdgeInsets.only(left: 15),
    child: Column(
      children: [
        // Profile image
        CircleAvatar(
          backgroundImage: NetworkImage(user.profileImg),
          radius: 37,
        ),

        // Profile username
        SizedBox(height: 10),
        Text(
          '${user.name}'.capitalizeFirst.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        Text(
          '${user.bio}',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
      ],
    ),
  );
}

//profile stats(posts/followers/following)
Widget _profileStats(UserModel user,BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(bottom: 35),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Posts count
        _buildStatItem('${tr(LocaleKeys.lblPosts)}', user.posts.length),
    
        // Followers count
        GestureDetector(
          onTap: (){
            navigatorPush(context, FollowersFollowingsScreen(username: user.name,userId: user.uid));
          },
          child: _buildStatItem('${tr(LocaleKeys.lblFollowers)}', user.followers.length)),
    
        // Following count
        GestureDetector(
          onTap: (){
            navigatorPush(context, FollowersFollowingsScreen(username: user.name,userId: user.uid));
          },
          child: _buildStatItem('${tr(LocaleKeys.lblFollowing)}', user.followings.length)),
      ],
    ),
  );
}

//seperated widget of showing stat
Widget _buildStatItem(String label, int value) {
  return Container(
    width: 90,
    child: Column(
      children: [
        Text(label),
        SizedBox(height: 7),
        Text(value.toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

