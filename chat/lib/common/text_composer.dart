import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();

  TextComposer(this.sendMessage); 

  final Function({String text, File img}) sendMessage;
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;
  final TextEditingController controller = TextEditingController();

  void _reset(){
    controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera), 
            onPressed: () async{
              final File img = await ImagePicker.pickImage(source: ImageSource.camera);
              if(img == null) return;
              widget.sendMessage(img: img);
            }
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration.collapsed(
                hintText: "Enviar uma mensagem"
              ),
              onChanged: (text){
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text){
                widget.sendMessage(text: text);
                _reset();
              },
            )
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing ?(){
              widget.sendMessage(text: controller.text);
              _reset();
            } : null
          )
        ],
      ),
    );
  }
}