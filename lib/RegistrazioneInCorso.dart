import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:monitoraggio_sonno_fl/askMattina.dart';
import 'package:ringtone_player/ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegistrazioneInCorso extends StatefulWidget {
RegistrazioneInCorso({Key? key}) : super(key: key);
@override
_RegistrazioneInCorsoState createState() => _RegistrazioneInCorsoState();
}

class _RegistrazioneInCorsoState extends State<RegistrazioneInCorso> {

  void initState() {
    super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(child:  Scaffold(
        appBar: AppBar(
          title: const Text("REGISTRAZIONE IN CORSO"),
          leading: Container(), // non mostro la freccia indietro
        ),
        body: Center(

          child: Column(children: <Widget>[
            Text('registrando...'),
            ElevatedButton(
                onPressed: () {

                  stopRegistrazione();
                },
                child: Text('Ferma la registrazione'))
          ])

        )),
      onWillPop: () async{
      Get.dialog(SimpleDialog(
        title: Text("L'app è disabilitata mentre sta registrando. Per usarla devi fermare la registrazione"),
      ));
      return false;
      }
      );

  }



  stopRegistrazione() async{
    // per la registrazione
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
