import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/Components/TextInput.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: ListView(
          children: [
            Text("Flutter", style: Theme.of(context).textTheme.headline1,),
            TextInput(),
            TextInput()
          ],
        ),
      )
    );
  }
}
