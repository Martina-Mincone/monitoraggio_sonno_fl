import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:monitoraggio_sonno_fl/askMattina.dart';
import 'package:ringtone_player/ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SvegliaInCorso extends StatefulWidget {
  SvegliaInCorso({Key? key}) : super(key: key);
  @override
  _SvegliaInCorsoState createState() => _SvegliaInCorsoState();
}

class _SvegliaInCorsoState extends State<SvegliaInCorso> {

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop:() async{
          Get.dialog(SimpleDialog(
            title: Text("La sveglia è attiva. Spegnila per usare l'app"),
          ));
          return false;
        },
    child: Scaffold(
        appBar: AppBar(
          title: const Text("SVEGLIA"),
          leading: Container(), // non mostro la freccia indietro
        ),
        body: Center(

            child: Column(children: <Widget>[
              Text('Sveglia attiva...'),
              ElevatedButton(
                  onPressed: () {

                    stopSveglia();
                  },
                  child: Text('Ferma sveglia'))
            ])

        )
    )
    );
  }

  stopSveglia() async{
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
    RingtonePlayer.stop();
    AndroidAlarmManager.cancel(100);
    FlutterForegroundPlugin.stopForegroundService();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("statoSveglia", 'assente');
    prefs.setString('oraSveglia', 'assente');
    Get.to(() => AskMattina());

  }



}
