import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snackbar_content/flutter_snackbar_content.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

navigatorPush(BuildContext context, Widget route,
    [PageTransitionType type = PageTransitionType.fade]) {
  Navigator.push(context, PageTransition(child: route, type: type));
}

navigatorPushReplacement(BuildContext context, Widget route,
    [PageTransitionType type = PageTransitionType.fade]) {
  Navigator.pushReplacement(context, PageTransition(child: route, type: type));
}

showMessageSnackBar(
    {required String message, required BuildContext context, bool? isSuccess}) {
  var snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    
    backgroundColor: Colors.transparent,
    content: FlutterSnackbarContent(
      color: Colors.grey.shade900,
      
      message: '${message}',
      contentType: ContentType.success,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

String currentUserId = FirebaseAuth.instance.currentUser!.uid;

//loading widget
Widget loadingWidget({Color color = Colors.black, double size = 35}) {
  return Center(child: SpinKitFadingCircle(color: color, size: size));
}

Widget errorWidget(String errorMessage) {
  print("error message : ${errorMessage}");
  return Container(
    height: 500,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 20))
      ],
    ),
  );
}




Future<Uint8List?> pickImage(bool isCamera) async {
  // Use the ImagePicker to pick an image from the device
  final picker = ImagePicker();
  XFile? pickedFile = await picker.pickImage(source:isCamera? ImageSource.camera: ImageSource.gallery);

  if (pickedFile != null) {
    // Read the picked image file as bytes
    List<int> imageBytes = await pickedFile.readAsBytes();
    
    // Convert the image bytes to Uint8List
    Uint8List uint8List = Uint8List.fromList(imageBytes);

    return uint8List;
  }

  // If no image was picked, return null
  return null;
}
