import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/Utils/FirebaseInteractions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String _imageUrl = "";

  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  final picker = ImagePicker();

  bool _loaded = false;

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  void getProfileInfo() async {
    String email = await getEmail();
    DocumentSnapshot userInfo = await FirebaseInteractions.getDocument("profiles", email);
    setState(() {
      _emailController.text = userInfo.data()["mail"];
      _usernameController.text = userInfo.data()["username"];
      _imageUrl = userInfo.data()["profile_picture"];
      _loaded = true;
    });
  }

  @override
  void initState() {
    getProfileInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PROFILE"),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          IconButton(
              icon:
              Icon(Icons.check_circle),
              onPressed: () {
                FirebaseInteractions.updateDocument("profiles", _emailController.text, {
                  "username": _usernameController.text,
                  "profile_picture": _imageUrl
                });
                Navigator.of(context).pop();
              })
        ],
      ),
      body: (_loaded ? Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView(
              children: [
                Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),),
                GestureDetector(
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.2,
                    backgroundImage: NetworkImage(_imageUrl),
                    backgroundColor: Colors.transparent,
                    child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.4),
                        radius: MediaQuery.of(context).size.width * 0.2,
                        child: Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.2),
                          child: Text(
                            'Tap to Edit',
                            style: TextStyle(color: Colors.white,),
                          ),
                        )
                    ),
                  ),
                  onTap: () {
                    pickImage();
                  },
                ),
                Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),),
                TextFormField(
                  controller: _emailController,
                  enabled: false,
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
                Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),),
                TextFormField(
                  controller: _usernameController,
                  enabled: true,
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
                  keyboardType: TextInputType.emailAddress,
                ),
                Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),),
                SizedBox(
                  width:  MediaQuery.of(context).size.width * 0.5,
                  child: RaisedButton(
/*
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 80),
*/
                      child: Text("CHANGE PASSWORD"),
                      onPressed: () {

                      }
                  ),
                )
              ],
            ),
          )) : Center(
        child: CircularProgressIndicator(),
      )),
    );
  }

  Future pickImage() async {
    showDialog(context: context,
        builder: (_) => AlertDialog(
          title: Text('Change profile picture'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Where should we got the photo ?")
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Gallery'),
              onPressed: () async {
                final pickedFile = await picker.getImage(source: ImageSource.gallery);
                await FirebaseInteractions.uploadPhoto(File(pickedFile.path), _emailController.text);
                await FirebaseInteractions.updateDocument("profiles", _emailController.text, {
                  "profile_picture": "https://firebasestorage.googleapis.com/v0/b/flutter-6744b.appspot.com/o/profile_picture%2F" + Uri.encodeComponent(_emailController.text + ".jpg") + "?alt=media&token=43ca32a6-625a-4fc5-a9f0-5c95e056392b"
                });
                Navigator.of(context).pop();
                setState(() {
                  _imageUrl = "https://firebasestorage.googleapis.com/v0/b/flutter-6744b.appspot.com/o/profile_picture%2F" + Uri.encodeComponent(_emailController.text + ".jpg") + "?alt=media&token=43ca32a6-625a-4fc5-a9f0-5c95e056392b";
                });
              },
            ),
            TextButton(
              child: Text('Camera'),
              onPressed: () async {
                final pickedFile = await picker.getImage(source: ImageSource.camera);
                await FirebaseInteractions.uploadPhoto(File(pickedFile.path), _emailController.text);
                await FirebaseInteractions.updateDocument("profiles", _emailController.text, {
                  "profile_picture": "https://firebasestorage.googleapis.com/v0/b/flutter-6744b.appspot.com/o/profile_picture%2F" + Uri.encodeComponent(_emailController.text + ".jpg") + "?alt=media&token=43ca32a6-625a-4fc5-a9f0-5c95e056392b"
                });
                Navigator.of(context).pop();
                setState(() {
                  _imageUrl = "https://firebasestorage.googleapis.com/v0/b/flutter-6744b.appspot.com/o/profile_picture%2F" + Uri.encodeComponent(_emailController.text + ".jpg") + "?alt=media&token=43ca32a6-625a-4fc5-a9f0-5c95e056392b" + DateTime.now().millisecondsSinceEpoch.toString();
                });
              },
            ),
          ],
        )
    );
  }
}
