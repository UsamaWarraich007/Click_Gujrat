import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';

abstract class FCMNotification {
  Future<void> sendNotificationToUser(
      {required String fcmToken, required String title, required String body,});
}

class FCMNotificationService extends FCMNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final String _endPoint = "https://fcm.googleapis.com/fcm/send";
  final String _contentType = "application/json";
  final String _authorization = "key=AAAAJBkyt1A:APA91bHC8dco9ZU5NKtS_Gp5V-y_SiCErInO4oWsw_4ZACgumV4PSldMo94imI6zKXGtfMk21hn4hghWCrbTh-tkArhlJ0OgSE3Md83rw3OJEaFU0b7oj3cFbNR0ROFqHo7vzUH9pkZo";

  Future<Response> _sentNotification(
      String to, String title, String body,
      ) async {
    try {
      final dynamic data = json.encode({
        "to" : to,
        "priority" : "high",
        "notification" : {
          "title" : title,
          "body" : body,
        },
        "content_available" : true,
      });

      Response response = await post(Uri.parse(_endPoint), body: data, headers: {
        "Content-Type" : _contentType,
        "Authorization" : _authorization,
      });

      return response;
    } on Exception catch (e) {
      print("Exception:: $e");
      throw Exception(e);
    }
  }

  @override
  Future<void> sendNotificationToUser({required String fcmToken, required String title, required String body}) {
    return _sentNotification(fcmToken, title, body);
  }
}