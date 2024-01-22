// ignore_for_file: must_be_immutable
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:sm_project/sm/controllers/userController.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:sm_project/sm/view/commonWidgets/circleCameraButton.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  Uint8List? selectedImage;

  pickProfileImage() async {
    selectedImage = await pickImage(false);
    setState(() {});
  }

  editPost({required String uid})async{
    bool status = await ref.read(userControllerProvider.notifier).editUser(uid: uid,bio: bioController.text
    ,imageData: selectedImage,name: nameController.text);
    if(status){
      Navigator.pop(context);
    }
  } 

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(getUserByIdController(FirebaseAuth.instance.currentUser!.uid))
        .when(data: (user) {
      nameController.text = user.name;
      bioController.text = user.bio!;
      return Scaffold(
        appBar: AppBar(title: Text("Edit Profile"),
        bottom: PreferredSize(preferredSize: Size(1, 1), child: ref.watch(userControllerProvider)
                ? LinearProgressIndicator()
                : Container()),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              SizedBox(height: 30),

              //user profle image
              Center(
                child: Stack(
                  children: [
                    // ignore: unnecessary_null_comparison

                    selectedImage == null && user.profileImg != ""
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                  color: Theme.of(context).cardColor, width: 3),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.profileImg),
                              radius: 60,
                            ),
                          )
                        : selectedImage != null
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Theme.of(context).cardColor,
                                      width: 3),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: MemoryImage(selectedImage!),
                                  radius: 60,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade200, width: 3),
                                ),
                                child: CircleAvatar(
                                  child: Icon(IconlyBold.profile, size: 50),
                                  radius: 60,
                                ),
                              ),

                    //camerabutton
                    Positioned(
                      bottom: 1,
                      right: 3,
                      child: CircleCameraButton(
                        onPressed: () {
                          pickProfileImage();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              //user name field
              SizedBox(height: 35),
              TextField(
                controller: nameController,
                style: TextStyle(fontSize: 17),
                decoration: InputDecoration(
                  labelText: "Name",
                ),
              ),
              //bio field
              SizedBox(height: 25),
              TextField(
                controller: bioController,
                style: TextStyle(fontSize: 17),
                decoration: InputDecoration(
                  labelText: "Bio",
                ),
              ),

              Spacer(),
              Container(
                margin: EdgeInsets.only(left: 25, right: 15, bottom: 25),
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    editPost(uid: user.uid);
                  },
                  child: Text("Save"),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
              )
            ],
          ),
        ),
      );
    }, error: (e, s) {
      return Text(e.toString());
    }, loading: () {
      return loadingWidget();
    });
  }
}
