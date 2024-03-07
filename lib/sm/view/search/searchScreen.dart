// ignore_for_file: must_be_immutable
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/userController.dart';
import 'package:sm_project/sm/generated/locale_keys.g.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:sm_project/sm/view/profile/profileScreen.dart';

class SearchScreen extends ConsumerWidget {
  TextEditingController query = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            ///search bar
            SliverAppBar(
              pinned: false,
              floating: true,
              expandedHeight: 130,
              title: Text(tr(LocaleKeys.lblSearch)),
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 57, left: 15, right: 15),
                      child: TextField(
                        controller: query,
                        onSubmitted: (value) {
                          ref.watch(searchUserController(value));
                        },
                        decoration: InputDecoration(
                          hintText: tr(LocaleKeys.lblSearchUser),
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          contentPadding: EdgeInsets.only(
                            top: 0,
                            bottom: 0,
                            left: 20,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            //search results
            SliverToBoxAdapter(
              child: ref.watch(searchUserController(query.text)).when(
                data: (data) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          //navigate to profile screen
                          navigatorPush(
                            context,
                            ProfileScreen(userId: data[index].uid),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data[index].profileImg),
                        ),
                        title: Text("${data[index].name}"),
                      );
                    },
                  );
                },
                error: (error, s) {
                  return errorWidget(s.toString());
                },
                loading: () {
                  return loadingWidget();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
