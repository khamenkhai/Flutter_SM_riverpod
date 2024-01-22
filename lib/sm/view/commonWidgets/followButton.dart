import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/userController.dart';
import 'package:sm_project/sm/generated/locale_keys.g.dart';
import 'package:sm_project/sm/utils/utils.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({super.key, required this.ref,required this.targetUserId,this.width = 130,this.height = 30,this.fontSize = 14});
  final WidgetRef ref;
  final String targetUserId;
  final double width,height,fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ref.watch(getUserByIdController(FirebaseAuth.instance.currentUser!.uid)).when(
            data: (currentUser) {
      return Container(
        width: width,
        height: height,
        child: ElevatedButton(
            onPressed: () {
              ref.watch(userControllerProvider.notifier).followUser(targetUserId);
            },
            style: ElevatedButton.styleFrom(elevation: 0),
            child: Text(currentUser.followings.contains(targetUserId)
                ? tr(LocaleKeys.lblUnFollow)
                : tr(LocaleKeys.lblFollow),style:TextStyle(fontSize: fontSize))),
      );
    }, error: (e, s) {
      return Text("${e}");
    }, loading: () {
      return loadingWidget();
    }));
  }
}
