import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:sm_project/sm/services/notificationService.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:sm_project/sm/view/home/feedScreen.dart';
import 'package:sm_project/sm/view/activity/notiScreen.dart';
import 'package:sm_project/sm/view/post/addPostScreen.dart';
import 'package:sm_project/sm/view/profile/profileScreen.dart';
import 'package:sm_project/sm/view/search/searchScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List _mainPages = [
    FeedScreen(),
    SearchScreen(),
    FeedScreen(),
    NotiScreen(),
    ProfileScreen(userId: currentUserId),
  ];

  NotificationsService notificationsService = NotificationsService();

  @override
  void initState() {
    ///initialized notification services
    initNoti();
    super.initState();
  }

  ///to initialized localization services and firebae notification services
  initNoti() async {
    await notificationsService.getToken();
    await notificationsService.requestPermission();
    await notificationsService.firebaseNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mainPages[_currentIndex],
      bottomNavigationBar: DotNavigationBar(
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.grey.shade900,
        selectedItemColor: Colors.white,
        marginR: EdgeInsets.only(left: 45, right: 45, bottom: 11, top: 15),
        paddingR: EdgeInsets.symmetric(vertical: 5),
        currentIndex: _currentIndex,
        onTap: (index) async {
          if (index == 2) {
            setState(() {
              _currentIndex = 0;
              navigatorPush(context, PostScreen());
            });
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        dotIndicatorColor: Colors.transparent,
        items: [
          /// Home
          DotNavigationBarItem(
            icon: Icon(_currentIndex == 0 ? IconlyBold.home : IconlyLight.home),
          ),

          /// Search
          DotNavigationBarItem(
            icon: Icon(IconlyLight.search),
          ),

          /// Search
          DotNavigationBarItem(
            icon: Icon(_currentIndex == 2
                ? IconlyBold.editSquare
                : IconlyLight.edit_square),
          ),

          /// Likes
          DotNavigationBarItem(
            icon:
                Icon(_currentIndex == 3 ? IconlyBold.heart : IconlyLight.heart),
          ),

          /// Profile
          DotNavigationBarItem(
            icon: Icon(
                _currentIndex == 4 ? IconlyBold.profile : IconlyLight.profile),
          ),
        ],
      ),
    );
  }
}
