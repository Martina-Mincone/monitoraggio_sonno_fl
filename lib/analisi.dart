import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:monitoraggio_sonno_fl/database/notteDB.dart';
import 'package:monitoraggio_sonno_fl/listaNotti.dart';
import 'package:monitoraggio_sonno_fl/valoriNotte.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';



class Analisi extends StatefulWidget {
  @override
  _MyAnalisiState createState()
  {
    return _MyAnalisiState();
  }
}

class _MyAnalisiState extends State<Analisi> {

  int idSelezionato = -1;
  String visualizza = 'valori'; //variabile usata per cambiare la visualizzazione dalla lista ai valori della notte selezionata

  bool caricamento = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
       child: visualizzaWidget()
      ),
    );
  }

  void callback(id) {
    if(id!=-1){  // utilizzo -1 per chiamare callback in valoriNotte. In quel caso l'idSelezionato non va modificato
      this.idSelezionato = id;
    }
    if(visualizza=='lista'){
      visualizza = 'valori';
    }else{visualizza = 'lista';}
    print('id selezionato è ${idSelezionato.toString()}');
    setState(() {
    });
  }
  Widget visualizzaWidget() {
    if(caricamento == true){
      return CircularProgressIndicator();
    }else{
    if (visualizza == 'lista') {
      return MyListaNotti(this.callback);
    } else { return MyValoriNotte(this.callback, idSelezionato);}
  }
  }
  refresh() async{
    var ultimaNotte = await NotteDatabase.instance.readLastNotte();
    if(ultimaNotte.id != -1){
      idSelezionato = ultimaNotte.id!;
    }else{
      visualizza = 'lista'; // se non ci sono dati visualizzo la lista vuota
    }
    setState(() {
      caricamento = false;
    });
  }




}


