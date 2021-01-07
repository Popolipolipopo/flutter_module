import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/Utils/SignWithGoogle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  double height;
  @override
  State<StatefulWidget> createState() =>
      LoginState();
}
class LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  String _errorMsg;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    skipIfConnected();
    super.initState();
  }

  void skipIfConnected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email");
    if (email != null && email.isNotEmpty) {
      print("Already logged as : " + email);
      Navigator.pushReplacementNamed(context, '/home');
    }
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
                          child: Text('Login', style: TextStyle(fontSize: 26)),
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
                        children: form(_emailController, _passwordController),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 80),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _login().then((result) {
                                if (result == true) {
                                  saveEmail();
                                  Navigator.pushReplacementNamed(context, '/home');
                                }
                              });
                            }
                          },
                          child: const Text('Sign in'),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: _signInButton(),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(_success == null
                            ? ''
                            : (_success
                            ? ''
                            : _errorMsg), style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('You have already an account ?'),
                          GestureDetector(
                            child: Text(' Sign up', style: TextStyle(color: Theme.of(context).primaryColor),),
                            onTap: () => Navigator.pushReplacementNamed(context, '/signUp'),
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

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().then((result) {
          if (result != null) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", _emailController.text);
  }

  Future<dynamic> _login() async {
    try {
      User user = (await auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,)
      ).user;
      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
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


  List <Widget> form(TextEditingController email, TextEditingController pass) {
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
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
      ),
    ];
  }
}
