import 'package:click_gujrat/Models/User.dart';
import 'package:click_gujrat/Models/user_info_model.dart' as info;
import 'package:click_gujrat/Services/api_services.dart';
import 'package:click_gujrat/Widgets/toaster.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'DatabaseServices.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
 // bool isEmailVerified=false;

  UserModel? _userFromFirebase(User? user) {
    if (user != null) {
      notifyListeners();
    }
    return user !=null ? UserModel(uid:user.uid) : null;
  }
  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges()
        .map(_userFromFirebase);
  }

  Future<UserModel?> signIn(String email,String password) async {
    try{
      UserCredential userCredential=await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user=userCredential.user;
        await updateUserInfo("");
        return _userFromFirebase(user);
    } on FirebaseAuthException catch(e){
      print(e.message);
      Toaster.showToast(e.code);
      return null;
    }
  }

  Stream<User?> authState() {
    notifyListeners();
    return _firebaseAuth.authStateChanges();
  }

  Future<UserModel?> signUp(String name,String email,String password,String gender) async{
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.currentUser!.updateDisplayName(name);
      User? user = userCredential.user;
      await DatabaseService(uid:user?.uid).addUserData(name, gender);
      await signOut();
      return _userFromFirebase(user);
    } on FirebaseAuthException catch(e){
      print(e.message);
      Toaster.showToast(e.code);
      return null;
    }
  }

  Future<Iterable<info.UserInfo>> getAData(int role) async {
    final admin = await Api(path: "User").adminDataCollection(role).then((value) {
      return value.docs.map((e) {
        return info.UserInfo.fromFirestore(e, SnapshotOptions());
      });
    });
    return admin;
  }

  User? getUser() {
    return _firebaseAuth.currentUser;
  }

  Future<info.UserInfo> getUserInfo({String? uid}) async {
    if (uid != null) {
      return await DatabaseService(uid: uid).getUserData();
    }
    User? user = getUser();
    return await DatabaseService(uid:user?.uid).getUserData();
  }

  Stream<info.UserInfo> streamUserInfo() {
    User? user = getUser();
    return DatabaseService(uid:user?.uid).streamUserData();
  }

  Future updateUserInfo(String image, ) async {
    var _user = await getUserInfo();
    try {
      if (image.isEmpty) {
        return await DatabaseService(uid: getUser()!.uid).updateUserData(_user.name, _user.gender, _user.image, _user.role);
      }
      await _firebaseAuth.currentUser!.updatePhotoURL(image);
      return await DatabaseService(uid: getUser()!.uid).updateUserData(_user.name, _user.gender, image, _user.role);
    } on FirebaseAuthException catch (e) {
      Toaster.showToast(e.code);
    }
  }

  Future<bool> updateProfile(String name, String gender, String image) async {
    try {
      await _firebaseAuth.currentUser!.updateDisplayName(name);
      await _firebaseAuth.currentUser!.updatePhotoURL(image);
      // print('all ok');
      // await _firebaseAuth.currentUser!.updateEmail(email);
      // print('email ok');
      return await DatabaseService(uid: getUser()!.uid).updateUserData(name, gender, image, Roles.roles);
    } on FirebaseAuthException catch (e) {
      Toaster.showToast(e.code);
      return false;
    }
  }

  Future<bool> validatePassword(String password) async {
    var firebaseUser = getUser();

    var authCredentials = EmailAuthProvider.credential(
        email: firebaseUser!.email!, password: password);
    try {
      var authResult = await firebaseUser
          .reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updatePassword(String password) async {
    var firebaseUser =  getUser();
    try {
      await firebaseUser!.updatePassword(password);
    } on FirebaseAuthException catch (e) {
      print(e);
      Toaster.showToast(e.message!);
    }
  }

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
    notifyListeners();
  }
}