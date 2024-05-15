import 'package:flutter/material.dart';
import 'package:sm_project/sm/models/storyModel.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:story_view/story_view.dart';

class StoryViewScreen extends StatefulWidget {
  final List<StoryModel> stories;
  const StoryViewScreen({
    Key? key,
    required this.stories,
  }) : super(key: key);

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    initStoryPageItems();
  }

  void initStoryPageItems() {
    for (int i = 0; i < widget.stories.length; i++) {
      storyItems.add(StoryItem.pageImage(
        url: widget.stories[i].storyImg.toString(),
        controller: controller,
      ));
    }
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: storyItems.isEmpty
          ?  loadingWidget()
          : StoryView(
              storyItems: storyItems,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }
}