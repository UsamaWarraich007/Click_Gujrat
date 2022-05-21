import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'push_notification_services.dart';

class AppServices {
  static final AppServices _instance = AppServices._();

  AppServices._();

  factory AppServices() => _instance;

  Future<void> initServices() async {
    try {
      await Get.putAsync(()=> Firebase.initializeApp());
      await Get.putAsync(()=> PushNotificationsManager().init());
    } on Exception catch (e) {
      print("Firebase InitializeApp Error::: $e");
    }

  }
}