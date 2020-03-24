import 'package:chat/view/chat_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(MyApp());
  //ESCREVER DADOS
  // Firestore.instance.collection("mensagens").document().setData({
  //   "from": "gustavo",
  //   "read": false,});

  //LER DADOS
  // QuerySnapshot snapshot = await Firestore.instance.collection('mensagens').getDocuments();
  // snapshot.documents.forEach((d){
  //   print(d.data)
  // });

  //SABER ATUALIZACOES (Primeira vez recebe todos os documentos da coleçao, depois recebe toda a coleç)
  Firestore.instance.collection('mensagens').snapshots().listen((dado){
    dado.documents.forEach((d){
      print(d.data);
    });
  });
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(color: Colors.blue)
      ),
      home: ChatScreen()
    );
  }
}
