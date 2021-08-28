import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitoraggio_sonno_fl/RegistrazioneInCorso.dart';
import 'package:monitoraggio_sonno_fl/database/notteDB.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/notte.dart';

class AskSera extends StatefulWidget {
  AskSera({Key? key}) : super(key: key);
  @override
  _AskSeraState createState() => _AskSeraState();
}

class _AskSeraState extends State<AskSera> {
  late var ora;
  //late List<Notte> notti;
  bool isLoading = false;

  String notteProva = 'prova';
  double stanchezza = 1.0;
  double tensione = 1.0;
  String attivita = '';
  List<bool> _selections =
      List.generate(6, (_) => false); // all'inizio nessuno è selezionato

  void initState() {
    super.initState();
    refreshNotti();
    // setta sveglia e eventualmente notifica e registrazione
  }

  Future refreshNotti() async{
    setState(() => isLoading= true);
    ora = DateTime.now();
    String oraStringa = ora.toIso8601String(); // per passare la stringa alle shared preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("inizioRegistrazione", oraStringa);

    var notte = Notte(id: null, data_ora_inizio: ora, data_ora_fine: null, stanchezza: 0, umore: 0, qualita_sonno: 0, attivita: '', db_medi: 0, tensione: 0 );
    int id = await NotteDatabase.instance.create(notte); // inizializzo la notte

    var ultimaNotte = await NotteDatabase.instance.readNotte(id);
    var notti = await NotteDatabase.instance.readAllNotte();
    print(notti.toString());
    print(id.toString());
    this.notteProva = ultimaNotte.attivita.toString()+ultimaNotte.stanchezza.toString();
    setState(() => isLoading= false);
    //setState(() => this.notteProva = notti.toString());

  }




  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async{
      Get.dialog(SimpleDialog(
        title: Text('Rispondi alle domande. Se non vuoi rispondere premi  "Skip"'),
      ));
      return false;
    },
    child: Scaffold(
        appBar: AppBar(
          title: const Text("DOMANDA SERALE"),
          leading: Container(), // non mostro la freccia indietro
        ),
        body: Center(
          child: Column(children: <Widget>[
            ElevatedButton(
              child: Text('go Back ... Stanchezza: $stanchezza'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text('selezione: ${_selections.toString()}'),
            Text('stanchezza: '),
            Slider(
              value: stanchezza,
              onChanged: (newStanchezza) {
                setState(() => stanchezza = newStanchezza);
              },
              min: 1,
              max: 5,
              divisions: 4,
              label: '${stanchezza.toInt()}' + '/' + '5',
            ),
            Text('Tesnione: '),
            Slider(
              value: tensione,
              onChanged: (newTensione) {
                setState(() => tensione = newTensione);
              },
              min: 1,
              max: 5,
              divisions: 4,
              label: '${tensione.toInt()}' + '/' + '5',
            ),
            ToggleButtons(children: [
              Icon(Icons.local_cafe),
              Icon(Icons.fastfood),
              Icon(Icons.train),
              Icon(Icons.directions_run),
              Icon(Icons.wine_bar),
              Icon(Icons.monitor)
            ], isSelected: _selections,
            onPressed: (int index){
              setState(() {
                _selections[index] = !_selections[index];
              });
            },),

            ElevatedButton(onPressed: salva,
                child: Text('Salva')),
            ElevatedButton(onPressed: skip,
                child: Text('Skip')),
            Text(notteProva),
          ]),
        ))
    );
  }

  salva() async{
    for(int i =0; i<_selections.length; i++){
      if(_selections[i]==true){
        switch(i){
          case 0: attivita=attivita + ' '+ 'caffe'; break;
          case 1: attivita=attivita + ' '+ 'cibo'; break;
          case 2: attivita=attivita + ' '+ 'treno'; break;
          case 3: attivita=attivita + ' '+ 'sport'; break;
          case 4: attivita=attivita + ' '+ 'alcool'; break;
          case 5: attivita=attivita + ' '+ 'tv'; break;
        }
      }
    }



    await NotteDatabase.instance.updateSeraByDataInizio(ora, stanchezza.toInt(), tensione.toInt(), attivita);
    Get.to(()=> RegistrazioneInCorso());//Get.to(() => MyHomePage());
  }

  skip(){
    Get.to(()=> RegistrazioneInCorso());//Get.to(() => MyHomePage());
  }
}
