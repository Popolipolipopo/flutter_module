import 'package:flutter/material.dart';
import 'Pages/HomePage.dart';
import 'Pages/Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        accentColor: Colors.cyan[600],
        backgroundColor: Colors.purple,
        // Define the default font family.
/*
        fontFamily: 'Georgia',
*/

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize:/* MediaQuery.of(context).size.width * 0.07*/ 15, fontWeight: FontWeight.bold, color: Colors.white),
          bodyText1: TextStyle(fontSize:/* MediaQuery.of(context).size.width * 0.05*/ 12, color: Colors.white),
        ),
      ),
      home: Login(),
    );
  }
}
