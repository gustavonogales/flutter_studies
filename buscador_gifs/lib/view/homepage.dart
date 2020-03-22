import 'dart:convert';
import 'package:buscador_gifs/view/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;
  int _limit = 19;
  int _offset = 0;

  Future<Map> _getGifs() async{
    http.Response response;

    if(_search == null || _search.isEmpty){
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=js5GdbNU9A2mgI9AK1LHUCZQ9LEaH2Id&limit=${_limit+1}&rating=G");
    }
    else{
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=js5GdbNU9A2mgI9AK1LHUCZQ9LEaH2Id&q=$_search&limit=$_limit&offset=$_offset&rating=G&lang=en");
    }

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise Aqui!",
                labelStyle: TextStyle(
                  color: Colors.white
                ),
                border: OutlineInputBorder()
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0
              ),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      alignment: Alignment.center,
                      width: 200.0,
                      height: 200.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if(snapshot.hasError) return Container();
                    else return _createGifTable(context, snapshot);
                }
              }
            )
          )
        ]
      )
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0
      ), 
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index){
        if(_search == null || index < snapshot.data["data"].length) {
          return GestureDetector(
            onTap: (){
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))
              );
            },
            onLongPress: (){
              Share.share(snapshot.data["data"][index]['images']['fixed_height']['url']);
            } ,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage, 
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover
            ),
          );
        } else {
          return Container(
            child: GestureDetector(
              onTap: (){
                setState(() {
                  _offset+=_limit;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add, 
                    color: Colors.white, 
                    size: 70.0
                  ),
                  Text("Carregar mais...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0
                    ),
                  )
                ],
              ),
            ),
          );
        }
        
      }
    );
  }

  int _getCount(List data){
    if(_search == null){
      return data.length;
    }
    else{
      return data.length+1;
    }
  }
}