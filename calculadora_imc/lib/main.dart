import 'package:flutter/material.dart';

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
  
  String _infoText = "Informe seus dados!";
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetField(){
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText =  "Informe seus dados!";
      _formKey = GlobalKey<FormState>();
    });
  }

  void calculate(){
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight/(height*height);
      
      if(imc < 18.6){_infoText = "Abaixo do peso \n IMC: ${imc.toStringAsPrecision(4)}";}
      else if(imc < 24.9){_infoText = "Peso ideal \n IMC: ${imc.toStringAsPrecision(4)}";}
      else if(imc < 29.9){_infoText = "Levemente acima do peso \n IMC: ${imc.toStringAsPrecision(4)}";}
      else if(imc < 34.9){_infoText = "Obesidade Grau I \n IMC: ${imc.toStringAsPrecision(4)}";}
      else if(imc < 40){_infoText = "Obesidade Grau II \n IMC: ${imc.toStringAsPrecision(4)}";}
      else{_infoText = "Obesidade Grau III \n IMC: ${imc.toStringAsPrecision(4)}";}
      
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),  
            onPressed: _resetField,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(Icons.person, size: 120.0, color: Colors.green),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Peso (kg)",
                labelStyle: TextStyle(color: Colors.green)
              ),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green, fontSize: 25.0),
              controller: weightController,
              validator: (value){
                if(value.isEmpty){
                  return "Insira seu peso!";
                }
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Altura (cm)",
                labelStyle: TextStyle(color: Colors.green)
              ),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green, fontSize: 25.0),
              controller: heightController,
              validator: (value){
                if(value.isEmpty){
                  return "Insira sua altura!";
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom:10.0),
              child: Container(
                height: 50.0,
                child: RaisedButton(
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      calculate();
                    }
                  },
                  child: Text(
                    "Calcular", 
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 25.0)
                    ),
                  color: Colors.green,
                ),
              ),
            ),
            Text(
              _infoText,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green, fontSize: 25.0),
            )
          ]) )
        )
    );
  }
}