import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsPushMessage {
  static void initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      bool autorize) async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launchef');
    final DarwinInitializationSettings iOSInitialize =
        DarwinInitializationSettings(
      requestSoundPermission: autorize,
      requestBadgePermission: autorize,
      requestAlertPermission: autorize,
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initializationsSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification(
      {required int id,
      required String title,
      required String body,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'you_can_name_it_whateverl',
      'channel_name',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );
    var not = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails());
    await fln.show(id, title, body, not);
  }
}
