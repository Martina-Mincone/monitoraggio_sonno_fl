import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/notte.dart';
import 'database/notteDB.dart';
import 'notification_service.dart';

/*
class listaNotti extends StatelessWidget{


  @override
  Widget build(BuildContext context){
    return Center(
        child: MyListaNotti()
    );
  }
}*/

class MyListaNotti extends StatefulWidget {

  late Function callback ;
  MyListaNotti(this.callback);


  @override
  _MyListaNottiState createState()
  {
    return _MyListaNottiState();
  }
}

class _MyListaNottiState extends State<MyListaNotti> {
  List<Notte> notti= [];
  bool caricamento = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: vistaPrincipale()
      ),
    );
  }

  Widget vistaPrincipale(){
    if(caricamento == false){
    if(notti.length!=0){
     return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: notti.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
              height: 50,
              color: Colors.lightBlue,
              child: Center(
                  child: ListTile(
                    title: //ElevatedButton(
                    //onPressed:mostraNotte(notti[index].id), // this.widget.callback(notti[index].id),
                    //child:
                    Text('Notte: ${notti[index].id.toString()}')
                    ,
                    trailing: IconButton(
                      onPressed: () { eliminaNotte(notti[index].id); },
                      icon: Icon(Icons.delete_rounded),),
                    leading: IconButton(
                      onPressed: () { mostraNotte(notti[index].id); },
                      icon: Icon(Icons.analytics_outlined),),

                  )
              )
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
      );
    }else{
      return Text('Non sono presenti notti');
    }
  }else{
      return CircularProgressIndicator();
    }
  }


  mostraNotte(id){
    //mostra la pagina
    this.widget.callback(id);

    print('hai sel ${id.toString()}');
  }
  eliminaNotte(id) async{
    setState(() {
      caricamento = true;
    });
    await NotteDatabase.instance.deleteById(id);
    await initList();
  }

  Future<void> initList() async {

    notti = await NotteDatabase.instance.readAllNotte();

    setState(() {
      caricamento = false;
    });
  }




}


