import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main(){
  runApp(MaterialApp(
    home: new Home()
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> lista = new List<String>();
  TextEditingController input = new TextEditingController();

  void adicionaItem(){
    setState(() {
      if(input.text != "" ){ lista.add(input.text); }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shitty List"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 15.0, right:15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:30.0, bottom:30.0),
                child: Text(
                  "Adicione items na lista!",
                  textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.0
                    ),
                )
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: input,
                decoration: InputDecoration(
                  labelText: "Novo Item",
                  labelStyle: TextStyle(fontSize: 20.0)
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom:15.0),
                child: RaisedButton(
                  onPressed: (){
                    adicionaItem();
                  },
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                    "Adicionar Item",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),),
                ),
              ),
               new Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 1500.0,
            child: new ListView.separated(
              itemCount: lista.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                  child: ListTile(
                    title: Text(lista[index])
                  ),
                );
              },
              separatorBuilder: (context, index){
                return Divider();
              },
              
            ),
          ),
        ),
        new IconButton(
          icon: Icon(Icons.remove_circle),
          onPressed: () {},
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    )
          ]),
        )));
  }
}