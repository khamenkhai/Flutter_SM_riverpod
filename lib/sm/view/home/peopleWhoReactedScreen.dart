import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/postController.dart';
import 'package:sm_project/sm/controllers/userController.dart';
import 'package:sm_project/sm/utils/utils.dart';

class PeopleWhoReactedScreen extends ConsumerWidget {
  const PeopleWhoReactedScreen({super.key, required this.postId});
  final String postId;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("People who reacted"),
      bottom: PreferredSize(child: Divider(), preferredSize: Size(0,0)),
      ),
      body: ref.watch(getPostByIdControllerProvider(postId)).when(data: (data){
        return ListView.builder(
          itemCount: data.likes.length,
          itemBuilder: (context, index) {
            String personId = data.likes[index];
            return ref.watch(getUserByIdController(personId)).when(data: (user){
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.profileImg),
                ),
                title: Text(user.name),
              );
            }, error: (error,s){
        return errorWidget(s.toString());
      }, loading: (){
              return loadingWidget();
            });
          },
        );
      }, error: (error,s){
        return errorWidget(s.toString());
      }, loading: (){
        return loadingWidget();
      }),
    );
  }
}