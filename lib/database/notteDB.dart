import 'package:monitoraggio_sonno_fl/database/notte.dart';
import 'package:sqflite/sqflite.dart';

class NotteDatabase{
  static final NotteDatabase instance = NotteDatabase._init();

  static Database? _database;

  NotteDatabase._init();

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDB('notte.db'); // se non esiste lo inizializzo con questo nome
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    print('sono in init');
    final dbPath = await getDatabasesPath();
    final path = dbPath+filePath; //join(dbPath, filePath);
    return await openDatabase(path, version: 3, onCreate: _createDB);

  }

  Future _createDB(Database db, int version ) async{
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final data_ora_inizioType = 'TEXT NOT NULL';
    final data_ora_fineType = 'TEXT NULLABLE';
    final stanchezzaType = 'INTEGER NOT NULL';
    final umoreType = 'INTEGER NOT NULL';
    final qualita_sonnoType = 'INTEGER NOT NULL';
    final tensioneType = 'INTEGER NOT NULL';
    final attivitaType = 'TEXT NOT NULL';
    final db_mediType = 'real NOT NULL';


    await db.execute('''CREATE TABLE $tableNotti (
    ${NotteFields.id} $idType , 
    ${NotteFields.data_ora_inizio} $data_ora_inizioType,
    ${NotteFields.data_ora_fine} $data_ora_fineType,
    ${NotteFields.stanchezza} $stanchezzaType,
    ${NotteFields.tensione} $tensioneType,
    ${NotteFields.umore} $umoreType,
    ${NotteFields.qualita_sonno} $qualita_sonnoType,
    ${NotteFields.attivita} $attivitaType,
    ${NotteFields.db_medi} $db_mediType
    )''');
  }

  Future close()async{
    final db = await instance.database;
    db.close();
  }

  // operazioni CRUD
  Future<int> create(Notte notte) async{
    final db = await instance.database;

    final id = await db.insert(tableNotti, notte.toJson());
    print('sono in create');
    return id;
  }

  Future<Notte> readNotte(int id) async{
    final db = await instance.database;
    final maps = await db.query(
      tableNotti,
      columns: NotteFields.values,
      where: '${NotteFields.id} = ?',
      whereArgs: [id],
    );
if(maps.isNotEmpty){
  return Notte.fromJson(maps.first); // prendo il primo
}else{
  throw Exception('ID non trovato');
}

  }

  Future<List<Notte>> readAllNotte() async{ // notti che hanno data fine non nulla
  final db = await instance.database;
  // final result = db.rawQuery('SELECT * FROM $tableNotti ORDER BY ${NotteFields.id} ASC');

  final result = await db.query(
      tableNotti,
      where: '${NotteFields.data_ora_fine} IS NOT NULL',
  orderBy: '${NotteFields.id} DESC');
  return result.map((json)=>Notte.fromJson(json)).toList();
  }

  Future<Notte> readLastNotte() async{ // ultima notte con dati completi (data fine non nulla)
    final db = await instance.database;
    // final result = db.rawQuery('SELECT * FROM $tableNotti ORDER BY ${NotteFields.id} ASC');

    final result = await db.query(
        tableNotti,
        where: '${NotteFields.data_ora_fine} IS NOT NULL',
        orderBy: '${NotteFields.id} DESC',
    limit: 1);
    print(result.length.toString());
    if(result.isNotEmpty){
    return Notte.fromJson(result.first);}
    else return Notte(id: -1); // valore di default

  }

  Future<void> updateSeraByDataInizio(inizio, stanchezza, tensione, attivita ) async{
    final db = await instance.database;
    String ora = inizio.toIso8601String();
    print(ora);
    db.rawUpdate('UPDAtE $tableNotti SET ${NotteFields.stanchezza} = ?, ${NotteFields.tensione} = ?, ${NotteFields.attivita} = ? WHERE ${NotteFields.data_ora_inizio} = ?', [stanchezza, tensione, attivita, ora]);
    return ;
  }

  Future<void> updateMattinaByDataInizio(inizio, fineOra, umore, qualita) async{
    final db = await instance.database;
    String ora = inizio;
    String fine = fineOra.toIso8601String();
    print(ora);
    db.rawUpdate('UPDAtE $tableNotti SET ${NotteFields.data_ora_fine} = ?,  ${NotteFields.umore} = ?, ${NotteFields.qualita_sonno} = ? WHERE ${NotteFields.data_ora_inizio} = ?', [fine, umore, qualita, ora]);
    return ;
  }
  
  Future<void> deleteAll() async {
    final db = await instance.database;
    db.rawDelete('DELETE FROM $tableNotti');
  }
  
  Future<void> deleteById(id) async{
    final db = await instance.database;
    db.rawDelete('DELETE FROM $tableNotti WHERE ${NotteFields.id} = ?', [id]);
  }





}

