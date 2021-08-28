import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:monitoraggio_sonno_fl/salvaRegistrazioni.dart';
import 'dart:convert';
class Grafici {
  String nomeFile = '';
  List<double> listaValori = [];
  List<String> listaTempi= [];
  List<FlSpot> listaFlSpot=[];
  bool caricamentoCompletato = false;


  Grafici(nomeFile) {
   this.nomeFile = convertiSenzaPunto(nomeFile);
  } // va inizializzato con la data inizio registraazione

  Future inizializza()async{
    caricamentoCompletato = await caricaGrafico(); // inizializzazione
    costruisciFlSpots(); // innizializzazione
  }

  Widget disegnaGrafico() {

   if(caricamentoCompletato == false){
     return Text('DATI NON TROVATI');
   }else{
     return LineChart(
         LineChartData(
             minX: 0,
             maxY: 120,
             minY: 0,
             maxX: listaValori.length.toDouble()-1,
             titlesData: getTitleData(),
             lineBarsData: [
               LineChartBarData(
                   spots: listaFlSpot,
                 isCurved: true,
                 colors: [const Color(0xff23b6e6),
                 const Color(0xff02d39a)],
                 belowBarData: BarAreaData(
                   show: true,
                   colors: [const Color(0xff23b6e6),
                     const Color(0xff02d39a)].map((color) => color.withOpacity(0.3)).toList(),
                 ),
                 dotData: FlDotData(show: false)


               )
             ]
         )
     );
   }

}

  FlTitlesData getTitleData(){
   return FlTitlesData(show: true,
    rightTitles: SideTitles(showTitles: true,
        getTitles: (value){
          return "";
        }
    ),
       topTitles: SideTitles(showTitles: true,
           getTitles: (value){
             return "";
           }),
    bottomTitles: SideTitles(
      interval: 2,
      showTitles: true,
      getTitles: (value){
        if(value.toInt()==listaTempi.length-1){
          return listaTempi.last;
        }
        int mezzo = ((listaTempi.length-1)/2).toInt();
        if(value.toInt()==mezzo){
          return listaTempi[mezzo];
        }
        if(value.toInt()==0){
        return listaTempi.first;}
        return '';
      },
      margin: 8
    )
   );
  }


Future<bool> caricaGrafico() async{ // return true se la lettura è andata a buon fine
    try {
      String letturaValori = await StorageNotte.read(nomeFile + 'Valori');
      List<dynamic> listaValoriDynamic = json.decode(
          letturaValori); // è una list<dynamics>, va castata in list<double>
       listaValori = listaValoriDynamic.cast<double>();

     String letturaTempi = await StorageNotte.read(nomeFile + 'Tempi');
      var listaTempiDynamic = json.decode(
          letturaTempi); // è una list<dynamics>, va castata in list<DateTime>
    listaTempi = listaTempiDynamic.cast<String>();

    print('caricamento grafico completato');
    return true;
    }catch(exception){

      print('${exception.toString()}');
      return false;
    }
}

costruisciFlSpots() {
    listaFlSpot = [];
     for(int i=0; i<listaValori.length; i++){
      listaFlSpot.add(FlSpot(i.toDouble(), listaValori[i]));
    }
}


}