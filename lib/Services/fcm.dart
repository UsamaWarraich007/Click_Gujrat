import 'package:get/get.dart';

class Fcm {
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      Get.log(data);
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      Get.log(notification);
    }

    return Future<void>.value();
    // Or do other work.
  }
}