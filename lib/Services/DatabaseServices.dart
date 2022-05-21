import 'package:click_gujrat/Models/User.dart';
import 'package:click_gujrat/Models/user_info_model.dart';
import 'package:click_gujrat/Widgets/toaster.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({required this.uid});

  final CollectionReference users =
      FirebaseFirestore.instance.collection('User');

  Future addUserData(String name, String gender) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    await users
        .doc(uid)
        .set({
          "image": "",
          "uid": uid,
          'name': name,
          'token': token,
          'gender': gender,
          'role': Roles.roles,
        })
        .then((value) => print('add data'))
        .catchError((error) => print("error is:$error"));
    print(Roles.roles);
  }

  Future<bool> updateUserData(String name, String gender, String image, int role) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    var result = await users
        .doc(uid)
        .set({
          "image": image,
          "uid": uid,
          'name': name,
          'token': token,
          'gender': gender,
          'role': role,
        })
        .then((value) {
      return true;
    })
        .catchError((error) {
      print("error is:$error");
      Toaster.showToast(error.toString());
      return false;
    });
    return result;
  }

  Future<UserInfo> getUserData() async {
    return await users
        .doc(uid)
        .get()
        .then((value) => UserInfo.fromFirestore(value, SnapshotOptions()));
  }

  Stream<UserInfo> streamUserData()  {
    return users.doc(uid).snapshots().map((user) => UserInfo.fromFirestore(user, SnapshotOptions()));
  }
}
