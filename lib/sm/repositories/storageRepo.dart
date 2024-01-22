import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageRepositoryController = Provider((ref) => StorageRepository(firebaseStorage: FirebaseStorage.instance));

class StorageRepository {
  final FirebaseStorage firebaseStorage;

  StorageRepository({required this.firebaseStorage});


Future<String> storeFile({
  required String path,
  required Uint8List imageData,
}) async {
  try {
    Uint8List? image = await compressImage(imageData);
    final ref = firebaseStorage.ref().child(path);
    UploadTask uploadTask = ref.putData(image!);
    final snapshot = await uploadTask;
    return snapshot.ref.getDownloadURL();
  } catch (e) {
    throw Exception(e);
  }
}


Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }




Future<Uint8List?> compressImage(Uint8List imageData) async {
  List<int> compressedData = await FlutterImageCompress.compressWithList(
    imageData,
    quality: 65,
  );
  return Uint8List.fromList(compressedData);
}


}