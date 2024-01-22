import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PostImageView extends StatelessWidget {
  const PostImageView({
    required this.imageUrl,
    required this.postId
    //required this.imageProvider,
    // this.loadingBuilder,
    // this.backgroundDecoration,
    // this.minScale,
    // this.maxScale,
    // this.initialScale,
    // this.basePosition = Alignment.center,
    // this.filterQuality = FilterQuality.none,
  });
  final String imageUrl;
  final String postId;
  //final ImageProvider imageProvider;
  // final LoadingBuilder loadingBuilder;
  // final Decoration backgroundDecoration;
  // final dynamic minScale;
  // final dynamic maxScale;
  // final dynamic initialScale;
  // final Alignment basePosition;
  // final FilterQuality filterQuality;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        
      ),
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Hero(
          tag: postId,
          child: PhotoView(
            imageProvider: NetworkImage(imageUrl),
            // loadingBuilder: loadingBuilder,
            // backgroundDecoration: backgroundDecoration,
            // minScale: minScale,
            // maxScale: maxScale,
            // initialScale: initialScale,
            // basePosition: basePosition,
            // filterQuality: filterQuality,
          ),
        ),
      ),
    );
  }
}