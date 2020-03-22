import 'dart:io';

import 'package:url_launcher/url_launcher.dart';
import 'package:agenda_contatos/view/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:agenda_contatos/helpers/contact_helper.dart';

enum orderOptions {orderaz, orderza}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();
     _getAllContacts(); 
     print(contacts);
  }

  void _getAllContacts(){
    helper.getAllContacts().then((list){
      setState(() {
        contacts = list;
      });
    });
  }

  void _showContactPage({Contact contact}) async{
    final recContact = await Navigator.push(context, MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));

    if(recContact != null){
      contact != null ? await helper.updateContact(recContact) : await helper.saveContact(recContact);
      _getAllContacts();
    }
  }

  void _orderList(orderOptions result){
    switch(result){
      case orderOptions.orderaz:
        contacts.sort((a,b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case orderOptions.orderza:
        contacts.sort((a,b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {
      
    });
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(context: context, builder:(context){
      return BottomSheet(
        onClosing: (){}, 
        builder: (context){
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FlatButton(
                    onPressed: (){
                      launch("tel:${contacts[index].phone}");
                    }, 
                    child: Text("Ligar",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20.0
                      )
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FlatButton(
                    onPressed: (){
                      Navigator.pop(context);
                      _showContactPage(contact: contacts[index]);
                    }, 
                    child: Text("Editar",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20.0
                      )
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FlatButton(
                    onPressed: (){
                      helper.deleteContact(contacts[index].id);
                      setState(() {
                        contacts.removeAt(index);
                        Navigator.pop(context);
                      });
                    }, 
                    child: Text("Excluir",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20.0
                      )
                    )
                  ),
                )
              ]
            ),
          );
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<orderOptions>(
            onSelected: _orderList,
            itemBuilder: (context) => <PopupMenuEntry<orderOptions>>[
              const PopupMenuItem<orderOptions>(
                child: Text("Ordernar de A-Z"),
                value: orderOptions.orderaz
              ),
              const PopupMenuItem<orderOptions>(
                child: Text("Ordernar de Z-A"),
                value: orderOptions.orderza
              )
            ]
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index){
            return _contactCard(context, index);
          }
        ),
    );
  }

  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      onTap: (){
        // _showContactPage(contact: contacts[index]);
        _showOptions(context, index);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: contacts[index].img != null  ? FileImage(File(contacts[index].img)) : AssetImage("assets/images/person.png")
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].name ?? "",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(contacts[index].email ?? "",
                      style: TextStyle(
                        fontSize: 18.0
                      )
                    ),
                    Text(contacts[index].phone ?? "",
                      style: TextStyle(
                        fontSize: 18.0
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}