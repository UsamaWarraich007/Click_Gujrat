import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadFile {
  final storageRef = FirebaseStorage.instance.ref();
  Future<String> uploadFile(File file, bool isHomeImage) async {
    String path = file.path.substring(file.path.lastIndexOf("/") + 1, file.path.length);
    late Reference mountainsRef;
    if (isHomeImage) {
      mountainsRef = storageRef.child(path);
    } else {
      mountainsRef = storageRef.child("images/$path");
    }
    try {
      await mountainsRef.putFile(file);
      return await mountainsRef.getDownloadURL();
    } on FirebaseException catch (e) {
      print("Exception:: ${e.toString()}");
      return "";
    }
  }
}