import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String content;
  final GlobalKey formKey;

  TextInput({Key key, this.content, this.formKey}) : super(key: key);
  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.center,
      decoration: new InputDecoration(
        hintText: '1',
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(0.0),
          ),
          borderSide: new BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
