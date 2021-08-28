import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:monitoraggio_sonno_fl/askSera.dart';
import 'package:monitoraggio_sonno_fl/gestioneTempo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';


import 'notification_service.dart';

class Sveglia extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Center(
        child: MySveglia()
    );
  }
}

class MySveglia extends StatefulWidget {
  @override
  _MySvegliaState createState()
  {
    return _MySvegliaState();
  }
}

class _MySvegliaState extends State<MySveglia> {
  TimeOfDay selectedTime = TimeOfDay.now();
  late Future<String> _statoSveglia;
  String stato = '';
  String svegliaSuonera = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStato();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if(stato=='assente')
            ElevatedButton(
                onPressed: () {
                  _selectTime(context);
                },
                child: Text("Scegli orario della sveglia"),
              )
            else
              ElevatedButton(
                onPressed: () {
                  annullaSveglia();
                },
                child: Text("Annulla sveglia"),
              )
              ,
              if(svegliaSuonera!='assente')
              Text('la sveglia suonerà alle ore' + "$svegliaSuonera"),
            ],
        ),
      ),
    );
  }

  Future<void> checkStato() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
     stato = (prefs.getString('statoSveglia') ?? 'assente') ;
    svegliaSuonera = (prefs.getString('oraSveglia') ?? 'assente') ;



    setState(() {
      /*
      _statoSveglia = prefs.setString("statoSveglia", stato).then((bool success) {

        print('lo stato è: '+'${_statoSveglia}');
       return stato;
      });*/
    });
  }

  Future<void> annullaSveglia() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("statoSveglia", 'assente');
    prefs.setString("oraSveglia", 'assente');

    checkStato();
    AndroidAlarmManager.cancel(100);
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,

    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      GestioneTempo(timeOfDay); // setta l'allarme della sveglia
      Get.to(() => AskSera());
      /*checkStato();
      setState(() {
        selectedTime = timeOfDay;
      });*/
    }
  }
}


