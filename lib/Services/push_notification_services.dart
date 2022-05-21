import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationsManager extends GetxService {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;
  static final PushNotificationsManager _instance =
  PushNotificationsManager._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future init() async {
    // For iOS request permission first.
    await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    // background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      print("onResume::: $message");

      RemoteNotification? _notification = message.notification;
      // bool isNext = await checkMessageId(message.data["google.message_id"]);
      // if (!isNext) return;
      if (_notification != null) {
        print("Notification Data: ${_notification.toString()}");

      }
    });

    // terminate
    _messaging.getInitialMessage().then((RemoteMessage? message) {

      RemoteNotification? _notification = message?.notification;
      // bool isNext = await checkMessageId(message.data["google.message_id"]);
      // if (!isNext) return;

      if (_notification != null) {
        print("OnLaunch::: $message");

      }
    });

    // foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      print("OnMessage: $message");
      RemoteNotification? _notification = message.notification;
      if (_notification != null) {
          String? title = _notification.title;
          String? body = _notification.body;
          String myRoute = Get.currentRoute;


            alertOnNotification(
                title: title!, description: body!,);
      }

    });

    FirebaseMessaging.instance.getToken().then((String? token) async {
      assert(token != null);
      // Obtain shared preferences.
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("token", token!);
      print("Firebase Token: $token");
    });
    return this;
  }

  void alertOnNotification({required String title, required String description}) {
    Get.defaultDialog(
      title: title,
      textCancel: 'DISMISS',
      textConfirm: 'VIEW',
      onCancel: Get.back,
      middleText: description,
      onConfirm: Get.back,
    );
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }
}