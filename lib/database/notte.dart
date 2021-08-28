final String tableNotti = 'notti';

class NotteFields{

  static final List<String> values=[
    /// tutti i campi
    id, data_ora_inizio, data_ora_fine, tensione, attivita, stanchezza, umore, qualita_sonno, db_medi
  ];

  static final String id = '_id';
  static final String data_ora_inizio = 'data_ora_inizio';
  static final String data_ora_fine = 'data_ora_fine';
  static final String tensione = 'tensione';
  static final String attivita = 'attivita';
  static final String stanchezza = 'stanchezzza';
  static final String umore = 'umore';
  static final String qualita_sonno= 'qualita_sonno';
  static final String db_medi  = 'db_medi';
}

class Notte{

  final int? id;
  final DateTime? data_ora_inizio;
  final DateTime? data_ora_fine;
  final int? tensione;
  final String? attivita;
  final int? stanchezza;
  final int? umore;
  final int? qualita_sonno;
  final double? db_medi;

  const Notte({
    this.id,
    this.data_ora_inizio,
    this.data_ora_fine,
    this.tensione,
    this.attivita,
    this.stanchezza,
    this.umore,
    this.qualita_sonno,
    this.db_medi,
  });


  static Notte fromJson(Map<String, Object?> json) => Notte(
    id : json[NotteFields.id] as int?,
      data_ora_inizio : DateTime.parse(json[NotteFields.data_ora_inizio] as String),
    data_ora_fine: (json[NotteFields.data_ora_fine]!=null ? DateTime.parse(json[NotteFields.data_ora_fine] as String) : DateTime.now()),
      tensione : json[NotteFields.tensione] as int,
      attivita : json[NotteFields.attivita] as String,
      stanchezza : json[NotteFields.stanchezza] as int,
      umore : json[NotteFields.umore] as int,
      qualita_sonno : json[NotteFields.qualita_sonno] as int,
      db_medi : json[NotteFields.db_medi] as double
  );


  Map<String, Object?> toJson() {
    //trasforma gli oggetti in Map per usarli nel database
    return {
      NotteFields.id: id,
      NotteFields.data_ora_inizio: data_ora_inizio!.toIso8601String(),
      NotteFields.data_ora_fine: data_ora_fine,
      NotteFields.tensione: tensione,
      NotteFields.attivita: attivita,
      NotteFields.stanchezza: stanchezza,
      NotteFields.umore: umore,
      NotteFields.qualita_sonno: qualita_sonno,
      NotteFields.db_medi: db_medi
    };
  }
  @override
  String toString() {
    //per ottenere facilmente una descrizione dell'oggetto
    return 'Notte{id: $id, data_ora_inizio: $data_ora_inizio, data_ora_fine: $data_ora_fine, tensione: $tensione, attivita: $attivita, stanchezza: $stanchezza, umore : $umore, qualita_sonno: $qualita_sonno, db_medi: $db_medi}';
  }

}
