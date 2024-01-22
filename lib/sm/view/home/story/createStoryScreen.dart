import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/storyController.dart';
import 'package:sm_project/sm/models/userModel.dart';
import 'package:sm_project/sm/utils/utils.dart';

class CreateStoryScreen extends ConsumerStatefulWidget {
  const CreateStoryScreen({super.key,required this.user});

  final UserModel user;

  @override
  ConsumerState<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends ConsumerState<CreateStoryScreen> {
  Uint8List? storyImagefile;

  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    Uint8List? image = await pickImage(false);
    if (image != null) {
      setState(() {
        storyImagefile = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              storyImagefile != null
                  ? Image.memory(storyImagefile!)
                  : Container()
            ],
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    initData();
                  },
                  child: Text("Choose photo"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black
                  ),
                ),
                ElevatedButton(
                  onPressed: ()async {
                    if(storyImagefile!=null){
                      bool status = await ref.read(storyControllerProvider.notifier).createStory(storyImagefile!, widget.user);
                      if(status){
                        Navigator.pop(context);
                        showMessageSnackBar(message: 'Story shared successful!', context: context);
                      }
                    }else{
                      showMessageSnackBar(message: "Choose story image", context: context);
                    }
                  },
                  child: Text("Share"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
