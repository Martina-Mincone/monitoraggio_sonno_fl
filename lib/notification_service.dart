import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();


  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon'); // in res drawable di android

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

     flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
  sendNotify() async{
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      '12345',   //Required for Android 8.0 or after
      'prova', //Required for Android 8.0 or after
      'mioCanale', //Required for Android 8.0 or after
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        12345,
        "A Notification From My Application",
        "This notification was sent using Flutter Local Notifcations Package",
        platformChannelSpecifics,
        payload: 'data');
  }


}
Future onSelectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('Notification payload: $payload');
  }
  // await  Get.toNamed('/second');

}
Future<dynamic> onDidReceiveLocalNotification(int a, String? b, String? c, String? d)async{
  //per iOS
}