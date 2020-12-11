import 'package:beauty_textfield/beauty_textfield.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
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
                                child: Image.network(
                                  'https://s3-alpha-sig.figma.com/img/dd52/8426/ec36cc62092b0309cf73052cf33056cd?Expires=1608508800&Signature=WCytEJrMfInsBSl9oqlBtMs62i0HPHawzDvcrASWO5KS~mWtdRsCDoai7Tv~GxHkyRZUOoKic~-5l8tu375sNJdf5nIZ-MoSnG2X3~qIjFpzbYs-jyLc-Ox97JnIqVh5mDnsz5thGP8qlAPCU21IJ~cdHPPVUnficYdW8i7JSPoVeGiRTu3eYLehzHSdkS7NQ2hjQ8l-ECNM2WyUf-BZnwffar8wmo69UguwIen1cq8BWOOxVEZvW30oJlTy-VWwiCGSr1dYAs28MS3TcZQuBiYjmkNbjZA3jmnjNLh22dk1l7Ra47AdjL4gFUEomFh7cIRVlB-lyaIqJQRCes2JgQ__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
                                  height: widget.height * 0.2,
                                ),
                              ),
                              Text('WAVE', style: TextStyle(fontSize: 26),)
                            ],
                          )
                      ),
                      Column(
                        children: form(_emailController, _passwordController,
                            _passwordController2),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 80),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _register();
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
                            ? 'Successfully registered ' + _userEmail
                            : _errorMsg), style: TextStyle(color: Colors.red),),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('You have already an account ?'),
                          GestureDetector(
                            child: Text(' Sign in', style: TextStyle(color: Theme.of(context).primaryColor),),
                            onTap: () {},
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

  void _register() async {
    try {
      User user = (await auth.createUserWithEmailAndPassword(
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
  }


  List <Widget> form(TextEditingController email, TextEditingController pass,
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