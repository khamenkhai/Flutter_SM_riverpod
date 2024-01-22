// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class CircleCameraButton extends StatelessWidget {
   CircleCameraButton({
    super.key,
    required this.onPressed
  });

  Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)),
        child: Container(
          height: 40,
          width: 40,
          child: Center(child: Icon(IconlyLight.camera)),
        ),
      ),
    );
  }
}