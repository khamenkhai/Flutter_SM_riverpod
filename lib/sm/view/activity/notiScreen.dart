import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/notiController.dart';
import 'package:sm_project/sm/generated/locale_keys.g.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:sm_project/sm/view/post/viewPostScreen.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotiScreen extends ConsumerWidget {
  const NotiScreen({super.key});

  //to see the post
  void navigateToPostScreen(BuildContext context, String postId) {
    navigatorPush(context, ViewPostScreen(postId: postId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("${tr(LocaleKeys.lblNotifications)}")),
      body: ref.watch(getNotificationsOfUserProvider).when(
        data: (notis) {
          return ListView.separated(
              physics: BouncingScrollPhysics(),
              itemCount: notis.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                //noti message widget
                return GestureDetector(
                  onTap: () {
                    navigateToPostScreen(context, notis[index].postId!);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      children: [
                        //profile image
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            "${notis[index].senderProfile}",
                          ),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //user name and noti message
                            Row(
                              children: [
                                Text(
                                  notis[index].senderName.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 10),
                                Text("${notis[index].notiMessage}"),
                              ],
                            ),
                            SizedBox(height: 5),
                            //noti time
                            Text(
                              "${timeago.format(notis[index].dateTime!)}",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        error: (e, s) {
          return errorWidget(e.toString());
        },
        loading: () {
          return loadingWidget();
        },
      ),
    );
  }
}
