import 'dart:math';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:monitoraggio_sonno_fl/RegistrazioneInCorso.dart';
import 'package:monitoraggio_sonno_fl/SvegliaInCorso.dart';
import 'package:monitoraggio_sonno_fl/reccorder.dart';

import 'package:ringtone_player/ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';

class GestioneTempo{
  TimeOfDay selectedTime ;
  TimeOfDay now = TimeOfDay.now();


  GestioneTempo(this.selectedTime){
      var diffMinuti = selectedTime.minute -now.minute ;
      var diffOre = selectedTime.hour-now.hour;
      if(diffMinuti<0){
        diffMinuti= diffMinuti+60;
        if (diffOre<=0){
          diffOre = diffOre+23;
        }else{
          diffOre= diffOre-1;
        }
      }else{
      if (diffOre<0){
        diffOre = diffOre+24;
      }
      }
      print('ore: '+'${diffOre}');
      print('minuti: '+'${diffMinuti}');
      print('minuti adesso: '+'${now.minute}');
      print('minuti selezionati: '+'${selectedTime.minute}');

      //setAlarmManager(diffOre, diffMinuti);
      setSharedAndShowNotification();
      startForegroundService(diffOre, diffMinuti);
      cambiaGrafica();
    }

  Future<void> cambiaGrafica() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("statoSveglia", 'registrando');
  }




    void setSharedAndShowNotification() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("statoSveglia", 'registrando');

      String orarioSveglia =  "${selectedTime.hour}: ${(selectedTime.minute<10)? '0'+selectedTime.minute.toString() : selectedTime.minute.toString()}";
      await prefs.setString("oraSveglia", '$orarioSveglia');

      await showNotificaRegistrazioneInCorso();

  }

  Future<void> showNotificaRegistrazioneInCorso() async {

    // notifica
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid;
    var initializationSettingsIOS;
    var initializationSettings;
    initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotifica);// da notification_service
    initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotifica);


    //lancia notifica
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_ID', 'channel name', 'channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'test ticker',
      ongoing: true,
      autoCancel: false,
      fullScreenIntent: true,
    );

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.startForegroundService(1, "service", "foreground", notificationDetails: androidPlatformChannelSpecifics, payload: 'item x');
    await flutterLocalNotificationsPlugin.show(1, 'Registrazione in corso',
        'Premi per fermare la registrazione', platformChannelSpecifics,
        payload: 'registrazione');
  }

  static Future<void> showNotificaSvegliaInCorso() async {

    // notifica
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid;
    var initializationSettingsIOS;
    var initializationSettings;
    initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotifica);// da notification_service
    initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotifica);


    //lancia notifica
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_ID2', 'channel name 2', 'channel description 2',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'test ticker',
      ongoing: true,
      autoCancel: false,
      fullScreenIntent: true,
    );

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.startForegroundService(2, "service", "foreground", notificationDetails: androidPlatformChannelSpecifics, payload: 'item x');
    await flutterLocalNotificationsPlugin.show(2, 'Sveglia attiva',
        'Premi per fermare la sveglia', platformChannelSpecifics,
        payload: 'sveglia');
  }

  static Future<void> callback() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
    /*RingtonePlayer.play(
      alarmMeta: AlarmMeta(
        'dev.cruv.ringtone_player_example.MainActivity',
        'ic_alarm_notification',
        contentTitle: 'Alarm',
        contentText: 'Alarm is active',
        subText: 'Subtext',
      ),
      android: Android.ringtone,
      ios: Ios.electronic,
      loop: true, // Android only - API >= 28
      volume: 1.0, // Android only - API >= 28
      alarm: true, // Android only - all APIs
    );*/
    //await RingtonePlayer.ringtone();
    print('Alarm fired!');
RingtonePlayer.ringtone();
// notifica sveglia in corso
    showNotificaSvegliaInCorso();

   // await showNotificaSvegliaInCorso(); // mostro la notifica di sveglia
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("statoSveglia", 'suonando');
    prefs.setString('oraSveglia', 'assente');

  }

  static void startForegroundService(diffOre, diffMinuti) async {
    await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 30);
    await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
    // esegue globalForegroundService ogni 5 secondi
    await FlutterForegroundPlugin.startForegroundService(
      holdWakeLock: true,
      onStarted: () async{
        startForeground(diffOre, diffMinuti);
        Recorder.start();
        print("Foreground on Started");
      },
      onStopped: () {
        RingtonePlayer.stop();
        print('la lettura finale: ${Recorder.lettura}');
        Recorder.lettura = '';
        Recorder.stop();
        print("Foreground on Stopped");
      },
      title: "Alarm Service",
      content: "",
      iconName: "ic_stat_hot_tub",
    );
  }

 static globalForegroundService() async{
  }
static startForeground(diffOre, diffMinuti){
  AndroidAlarmManager.oneShot(
      Duration(hours: diffOre, minutes: diffMinuti),
      // Ensure we have a unique alarm ID.
      100, //Random().nextInt(pow(2, 31).toInt()),
      callback,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
      alarmClock: true
  );
}
}

Future onSelectNotifica(String? payload) async {
  if (payload != null) {
    debugPrint('Notification payload: $payload');
  }
  if (payload == 'registrazione'){
    print('vado in regisrazone');
    Get.to(() => RegistrazioneInCorso());}
  else if (payload == 'sveglia'){
    print('vado in sveglia');
    Get.to(() => SvegliaInCorso());}
}

Future<dynamic> onDidReceiveLocalNotifica(int a, String? b, String? c, String? d)async{
//per iOS
}
