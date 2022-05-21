import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  final String gender;
  final String name;
  final String uid;
  String image;
  final String token;
  final int role;

  UserInfo({
    required this.gender,
    required this.name,
    required this.uid,
    required this.token,
    required this.image,
    required this.role,
  });

  UserInfo.fromFirestore(
    DocumentSnapshot<Object?> snapshot,
    SnapshotOptions? options,
  )   : gender = snapshot["gender"],
        name = snapshot["name"],
        token = snapshot["token"],
        image = snapshot["image"],
        uid = snapshot["uid"],
        role = snapshot["role"];

  Map<String, dynamic> toFirestore() {
    return {
      "gender": gender,
      "name": name,
      "token": token,
      "uid": uid,
      "image": image,
      "role": role,
    };
  }
}
