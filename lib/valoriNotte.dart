import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:monitoraggio_sonno_fl/database/notte.dart';
import 'package:monitoraggio_sonno_fl/database/notteDB.dart';
import 'package:monitoraggio_sonno_fl/grafici.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'notification_service.dart';


class MyValoriNotte extends StatefulWidget {
  late Function callback ;
  late int idSelezionato;

  MyValoriNotte(this.callback, this.idSelezionato);

  @override
  _MyValoriNotteState createState()
  {
    return _MyValoriNotteState();
  }
}

class _MyValoriNotteState extends State<MyValoriNotte> {

  String dataSelezionata = '';
  List<bool> _selections =
    List.generate(6, (_) => false);

  bool caricamento = true;
  late Notte notteSelezionata;
  String differenzaSonno = '';
  List<String> attivita = [];
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
        child: vista()
      ),
    );
  }
  refresh() async{
    notteSelezionata = await NotteDatabase.instance.readNotte(this.widget.idSelezionato);
    Duration differenza = notteSelezionata.data_ora_fine!.difference(notteSelezionata.data_ora_inizio!);
    int ore = differenza.inHours;
    int minuti = differenza.inMinutes-ore*60;
    differenzaSonno = '$ore ore e $minuti minuti';
    attivita = notteSelezionata.attivita!.split(' ');
    dataSelezionata = DateFormat('yyyy-MM-dd – kk:mm').format(notteSelezionata.data_ora_inizio!);


    print(attivita.toString());
    _selections=[
      attivita.contains('caffe'),
      attivita.contains('cibo'),
      attivita.contains('treno'),
      attivita.contains('sport'),
      attivita.contains('alcool'),
      attivita.contains('tv')
    ];
    print(_selections.toString());

    setState(() {
      caricamento = false;
    });
  }
  Widget vista(){
    if(caricamento == true){
      return CircularProgressIndicator();
    }else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              this.widget.callback(-1);
            },
            child: Text("vai alla lista notti"),
          ),
          Text('Notte $dataSelezionata'),
          Text('Tensione: ${(this.notteSelezionata.tensione==0)? 'assente' : this.notteSelezionata.tensione.toString()+'/5' }'),
          Text('Umore: ${(this.notteSelezionata.umore==0)? 'assente' : this.notteSelezionata.umore.toString()+'/5' }'),
          Text('Qualità sonno: ${(this.notteSelezionata.qualita_sonno==0)? 'assente' : this.notteSelezionata.qualita_sonno.toString()+'/5' }'),
          Text('Stanchezza: ${(this.notteSelezionata.stanchezza==0)? 'assente' : this.notteSelezionata.stanchezza.toString()+'/5' }'),
          Text('Durata: $differenzaSonno'),
          ToggleButtons(children: [
            Icon(Icons.local_cafe),
            Icon(Icons.fastfood),
            Icon(Icons.train),
            Icon(Icons.directions_run),
            Icon(Icons.wine_bar),
            Icon(Icons.monitor)
          ], isSelected: _selections,
            onPressed: (int index){
              },
            ),
          Container(
            height: 200,
            child: grafico()
          )
        ],
      );
    }
  }

  Widget grafico(){
    if(caricamento == true){
      return CircularProgressIndicator();
    }else {
      Grafici grafico = new Grafici(this.notteSelezionata.data_ora_inizio);
      return FutureBuilder(
      future: grafico.inizializza(),
        builder: (context, snapshot){
       if(snapshot.connectionState==ConnectionState.waiting){
            return CircularProgressIndicator();}
       else{
            return grafico.disegnaGrafico();}
        }
        );
    }    
  }



}


