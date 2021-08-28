import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitoraggio_sonno_fl/database/notteDB.dart';
import 'package:monitoraggio_sonno_fl/main.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AskMattina extends StatefulWidget {
  AskMattina({Key? key}) : super(key: key);
  @override
  _AskMattinaState createState() => _AskMattinaState();
}

class _AskMattinaState extends State<AskMattina> {
  late var ora;
  bool isLoading = false;
  String notteProva = 'prova';
  double umore = 1.0;
  double qualita = 1.0;

  void initState() {
    super.initState();
    refreshNotti();
  }

  Future refreshNotti() async{
    setState(() => isLoading= true);
    ora = DateTime.now();

    setState(() => isLoading= false);


  }




  @override
  Widget build(BuildContext context) {
    return new WillPopScope( onWillPop: () async{
      Get.dialog(SimpleDialog(
      title: Text('Rispondi alle domande. Se non vuoi rispondere premi  "Skip"'),
    ));
    return false; },
    child: Scaffold(
        appBar: AppBar(
          title: const Text("DOMANDA SERALE"),
          leading: Container(), // non mostro la freccia indietro
        ),
        body: Center(
          child: Column(children: <Widget>[
            Text('Umore: '),
            Slider(
              value: umore,
              onChanged: (newUmore) {
                setState(() => umore = newUmore);
              },
              min: 1,
              max: 5,
              divisions: 4,
              label: '${umore.toInt()}' + '/' + '5',
            ),
            Text('Qualità sonno: '),
            Slider(
              value: qualita,
              onChanged: (newQualita) {
                setState(() => qualita = newQualita);
              },
              min: 1,
              max: 5,
              divisions: 4,
              label: '${qualita.toInt()}' + '/' + '5',
            ),
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

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var inizio = (prefs.getString('inizioRegistrazione') ?? 'assente') ;

    await NotteDatabase.instance.updateMattinaByDataInizio(inizio, ora, umore.toInt(), qualita.toInt());
    Get.to(() => MyHomePage());
  }

  skip() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var inizio = (prefs.getString('inizioRegistrazione') ?? 'assente') ;

    await NotteDatabase.instance.updateMattinaByDataInizio(inizio, ora, 0, 0);
    Get.to(() => MyHomePage());
  }
}
