import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/storyController.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:sm_project/sm/view/home/story/storyViewScreen.dart';

class StoryScreen extends ConsumerStatefulWidget {
  const StoryScreen({super.key,required this.userId});
  final String userId;

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(getUserStoriesControllerProvider(widget.userId)).when(
        data: (data){
          return StoryViewScreen(stories: data);
        }, 
        error: (error,s){
          return Text("${error}");
        }, 
        loading: loadingWidget);
    
  }
}