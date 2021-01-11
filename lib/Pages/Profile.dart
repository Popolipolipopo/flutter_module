import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/Utils/FirebaseInteractions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_module/Utils/SignWithGoogle.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import 'SinglePost.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String _imageUrl = "";
  String _urlFirestore = "";
  String mail;

  List<DocumentSnapshot> _likes = List<DocumentSnapshot>();
  List<DocumentSnapshot> _posts = List<DocumentSnapshot>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  int _selected = 0;

  final picker = ImagePicker();

  bool _loaded = false;

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  void getProfileInfo() async {

    mail = await getEmail();

    if (mail == null) {
      mail = email;
    }

    DocumentSnapshot userInfo = await FirebaseInteractions.getDocument("profiles", mail);
    List<DocumentSnapshot> posts = await FirebaseInteractions.getDocumentWithQuery("posts", "author", mail);
    List<DocumentSnapshot> likes = await FirebaseInteractions.getDocumentWithQueryContains("posts", "likes", mail);
    Map<String, dynamic> config = jsonDecode(await rootBundle.loadString('assets/config.json'));
    setState(() {
      _emailController.text = userInfo.data()["mail"];
      _usernameController.text = userInfo.data()["username"];
      _imageUrl = userInfo.data()["profile_picture"];
      _urlFirestore = config["firestore_url"] + "profile_picture/";
      _posts = posts;
      _likes = likes;
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
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          _selected = 0;
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0))),
                      child: Text('Your posts'),
                      color: _selected == 0 ? Colors.transparent : Theme.of(context).backgroundColor,
                      textColor: Colors.white,
                    ),
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          _selected = 1;
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0))),
                      child: Text('Your likes'),
                      color: _selected == 1 ? Colors.transparent : Theme.of(context).backgroundColor,
                      textColor: Colors.white,
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),),
                Container(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: _selected == 0 ? _posts.length : _likes.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        );
                      },
                      itemBuilder: (context, index) {
                        if (_selected == 0)
                          return SinglePost(postInfo: _posts[index], email: _emailController.text,);
                        else
                          return SinglePost(postInfo: _likes[index], email: _emailController.text,);
                      }),
                ),
                Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),),
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
                  "profile_picture": _urlFirestore + Uri.encodeComponent(_emailController.text + ".jpg") + "?alt=media"
                });
                Navigator.of(context).pop();
                setState(() {
                  _imageUrl = _urlFirestore + Uri.encodeComponent(_emailController.text + ".jpg") + "?alt=media";
                });
              },
            ),
            TextButton(
              child: Text('Camera'),
              onPressed: () async {
                final pickedFile = await picker.getImage(source: ImageSource.camera);
                await FirebaseInteractions.uploadPhoto(File(pickedFile.path), _emailController.text);
                await FirebaseInteractions.updateDocument("profiles", _emailController.text, {
                  "profile_picture": _urlFirestore + Uri.encodeComponent(_emailController.text + ".jpg") + "?alt=media"
                });
                Navigator.of(context).pop();
                setState(() {
                  _imageUrl = _urlFirestore + Uri.encodeComponent(_emailController.text + ".jpg") + "?alt=media" + DateTime.now().millisecondsSinceEpoch.toString();
                });
              },
            ),
          ],
        )
    );
  }
}