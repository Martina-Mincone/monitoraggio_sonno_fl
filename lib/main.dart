import 'dart:async';
import 'package:get/get.dart';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:monitoraggio_sonno_fl/RegistrazioneInCorso.dart';
import 'package:monitoraggio_sonno_fl/SvegliaInCorso.dart';
import 'package:monitoraggio_sonno_fl/analisi.dart';
import 'package:monitoraggio_sonno_fl/sveglia.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  //FlutterBackgroundService.initialize(onStart); // se lo chiamo da subito mi compare la notifica da subito
  //await stopService();
  await NotificationService().init();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String statoSveglia = (prefs.getString('statoSveglia') ?? 'assente') ;
  runApp(MyApp(statoSveglia));
}
/*
stopService() async{

    var isRunning =
        await FlutterBackgroundService().isServiceRunning();
    if (isRunning) {
      FlutterBackgroundService().sendData(
        {"action": "stopService"},
      );
    } else {
      FlutterBackgroundService.initialize(onStart);
    }
}


void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) {
    var tmp = event!["action"].toString().split('£');
    var tmp1= tmp[0];
    var tmp2= '';
    if(tmp.length>=2){
    var tmp2=tmp[1];}
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }

    if (tmp1== "registra") {
      service.setNotificationInfo(
        title: "My App Service",
        content: "lettura ${event!["action"].toString()}",
        //content: "Updated at ${DateTime.now()}",
      );
    }


  });

  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
      title: "My App Service",
      content: "lettura ${Recorder.lettura}",
      //content: "Updated at ${DateTime.now()}",
    );

    service.sendData(
      {"current_date": DateTime.now().toIso8601String()},
    );
  });
}*/

class MyApp extends StatelessWidget {

  String statoSveglia = '';
  MyApp(this.statoSveglia);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => WidgetIniziale()),
       // GetPage(name: '/second', page: () => SecondRoute()),
      ],
      //title: 'Prova Flutter',
      //home: MyHomePage(),
    );
  }

  Widget WidgetIniziale() {
    if(statoSveglia=='assente'){
    return MyHomePage();
    }else if(statoSveglia == 'registrando'){
      return RegistrazioneInCorso();
    }else{
      return SvegliaInCorso();
    }

  }


}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    Sveglia(),
    Analisi(),
    Text('statistica'),
    Text('Profilo',
        style: optionStyle),
  ];
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(onWillPop: ()  async { return false; },
    child:  Scaffold(
      appBar: AppBar(title: const Text("NavBar Titolo",),
        leading: Container(), // non mostro la freccia indietro
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: "Sveglia"),
          BottomNavigationBarItem(
              icon: Icon(Icons.graphic_eq),
              label: "Analisi"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "Statistica"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Profilo"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    ));
  }

}