import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Pages/HomePage.dart';
import 'Pages/Login.dart';
import 'Pages/Register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wave',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Color(0xFF7E6FEA),
        accentColor: Color(0xFFFFFFFF),
        scaffoldBackgroundColor: Color(0xFF2A3442),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Color(0xFF7E6FEA),
        ),
        // Define the default font family.
/*
        fontFamily: 'Georgia',
*/

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 15, color: Colors.white),
          bodyText1: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
      home: Login(),
    );
  }
}
