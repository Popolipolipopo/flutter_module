import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  double height;
  @override
  State<StatefulWidget> createState() =>
      RegisterState();
}
class RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  String urlFirestore = "https://firebasestorage.googleapis.com/v0/b/flutter-6744b.appspot.com/o/profile_picture%2Fdefault.jpg?alt=media&token=5abdbdf7-73fc-475a-9857-413d3879f64f";
  bool _success;
  String _errorMsg;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          children: [
            Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(top: widget.height * 0.05),
                  height: widget.height * 0.95,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Center(
                        child: Container(
                          child: Text('Register', style: TextStyle(fontSize: 26)),
                        ),
                      ),
                      Center(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset('assets/logo_wave.png', height: widget.height * 0.2,),
                              ),
                              Text('WAVE', style: TextStyle(fontSize: 26),)
                            ],
                          )
                      ),
                      Column(
                        children: form(_emailController, _userController,
                            _passwordController, _passwordController2),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 80),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _register().then((result) {
                                if (result == true)
                                  Navigator.pushReplacementNamed(context, '/home');
                              });
                            }
                          },
                          child: const Text('Sign up'),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(_success == null
                            ? ''
                            : (_success
                            ? ''
                            : _errorMsg), style: TextStyle(color: Colors.red)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('You have already an account ?'),
                          GestureDetector(
                            child: Text(' Sign in', style: TextStyle(color: Theme.of(context).primaryColor),),
                            onTap: () => Navigator.pushReplacementNamed(context, '/signIn'),
                          )
                        ],
                      )
                    ],
                  ),
                )
            ),
          ],
        )
    );
  }

  Future<dynamic> _register() async {
    try {
      User user = (await auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text)
      ).user;
      if (user != null) {
        await databaseReference.collection("profiles").doc(user.email)
            .set({
          'mail': user.email,
          'username': _userController.text,
          'profile_picture': urlFirestore,
        });
        setState(() {
          _success = true;
        });
      }
    } catch (e) {
      print('Case ${e.message} is not yet implemented');
      setState(() {
        _success = false;
        _errorMsg = e.message;
      });
    }
    return _success;
  }


  List <Widget> form(TextEditingController email, TextEditingController user,
      TextEditingController pass,
      TextEditingController confirm) {
    return [
      TextFormField(
        controller: email,
        decoration: new InputDecoration(
          labelText: "Email",
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(
            ),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
      ),
      SizedBox(height: widget.height * 0.03),
      TextFormField(
        controller: user,
        decoration: new InputDecoration(
          labelText: "Username",
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(
            ),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        keyboardType: TextInputType.text,
      ),
      SizedBox(height: widget.height * 0.03),
      TextFormField(
        controller: pass,
        decoration: new InputDecoration(
          labelText: "Password",
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(
            ),
          ),
        ),
        validator: (String value) {
          if (value != confirm.text) {
            return 'Passwords are not the same';
          }
          else if (value.isEmpty) {
            return 'Please enter some text';
          }
          else if (value.length < 6) {
            return 'Password to weak';
          }
          return null;
        },
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
      ),
      SizedBox(height: widget.height * 0.03),
      TextFormField(
        controller: confirm,
        decoration: new InputDecoration(
          labelText: "Confirm password",
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(
            ),
          ),
        ),
        validator: (String value) {
          if (value != pass.text) {
          return 'Passwords are not the same';
          }
          else if (value.isEmpty) {
            return 'Please enter some text';
          }
          else if (value.length < 6) {
            return 'Password to weak';
          }
          return null;
        },
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
      ),
    ];
  }
}