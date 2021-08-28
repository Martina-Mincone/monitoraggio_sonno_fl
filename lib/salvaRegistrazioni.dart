

import 'dart:io';

import 'package:path_provider/path_provider.dart';
class StorageNotte{
   static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> localFile(nomeFile) async {
    final path = await _localPath;
    return File('$path/$nomeFile.txt');
  }

  static Future<String> read(nomeFile) async {
    try {
      final file = await localFile(nomeFile);

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      print('eccezione in lettura: ${e.toString()}');
      return '';
    }
  }

  static Future<File> write(nomeFile, contenuto) async {
     nomeFile = convertiSenzaPunto(nomeFile);
    final file = await localFile(nomeFile);

    // Write the file
    return file.writeAsString('${contenuto.toString()}');
  }


}
String convertiSenzaPunto(fileName){ // utilizzato per salvare il file con un nome accettabile dal sistema
return fileName.toString().replaceAll(' ', 'T').replaceAll(':', 'd').replaceAll('.', 'p');
}