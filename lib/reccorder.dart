import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:monitoraggio_sonno_fl/salvaRegistrazioni.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Recorder{
  static bool isRecording = false;
  static StreamSubscription<NoiseReading>? _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
  static NoiseMeter _noiseMeter = new NoiseMeter(onError);
  static String lettura = '';
  static String nomeFile = '';
  static List<double> listaValori = [];
  static List<String> listaTempi = [];
  static int contatore = 0;


  static void onData(NoiseReading noiseReading) {
    if (!isRecording) {
      isRecording = true;
    };

    if(contatore%10==0){ // salva una ogni 10
      var tmp = noiseReading.toString().split(
        "dB"); // il valore si trova in posizione 2
    listaValori.add(double.parse(tmp[2]));
    String ora = DateFormat('kk:mm').format(DateTime.now());

    listaTempi.add('"' + ora + '"');
  }
      contatore++;
  }

 static void onError(PlatformException e) {
    print(e.toString());
    isRecording = false;
  }

  static void start() async {
    contatore=0;
    lettura = '';
    listaValori =[];
    listaTempi = [];
    await getNomeFile();
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
      //print('start recording');
    } catch (err) {
      print(err);
    }
  }
  static Future getNomeFile() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nomeFile = (prefs.getString('inizioRegistrazione') ?? 'assente') ;
    return ;
  }

  static void stop() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription!.cancel();
        _noiseSubscription = null;
      }
        isRecording = false;
    } catch (err) {
      print('stopRecorder error: $err');
    }
    await StorageNotte.write(nomeFile+'Valori', listaValori.toString());
    await StorageNotte.write(nomeFile+'Tempi', listaTempi.toString());


    lettura = '';

    listaValori = [];
    listaTempi = [];
  }
}