import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Post extends StatefulWidget {
  final void Function(int) onClick;

  const Post({Key key, this.onClick}) : super(key: key);
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  final databaseReference = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  File _imageFile;
  String _imageName;
  String _imageURL;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Theme.of(context).accentColor,),
                        onPressed: () => widget.onClick(0),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 80),
                        child: Text("Publish"),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            post().then((result) {
                              if (result == true)
                                widget.onClick(0);
                            });
                          }
                        }
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: textController,
                    decoration: new InputDecoration(
                      labelText: "What's up ?",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                    ),
                    minLines: 10,
                    maxLines: 11,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                  ),
                  Center(
                    child: (_imageFile == null)
                        ? SizedBox.shrink()
                        : GestureDetector(
                      onTap: () { setState(() {_imageFile = null;});},
                      child: Image.file(
                        _imageFile,
                        fit: BoxFit.fitWidth,
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  Center(
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, color: Theme.of(context).accentColor),
                      onPressed: () => pickImage(),
                    ),
                  )
                ],
              ),
            )
        )
    );
  }
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }
  Future uploadImageToFirebase(BuildContext context) async {
    _imageName = _imageFile.path.split('/')[(_imageFile.path.split('/').length)-1];
    print('object ' + _imageName);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('posts/$_imageName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    await uploadTask.whenComplete(() {
      print('File Uploaded');
      firebaseStorageRef.getDownloadURL().then((fileURL) {
        setState(() {
          _imageURL = fileURL;
        });
      });
    });
  }
  Future<dynamic> post() async {
    if (_imageFile != null)
      await uploadImageToFirebase(context);
    try {
      DocumentReference ref = await databaseReference.collection("posts")
          .add({
        'author': auth.currentUser.email,
        'message': textController.text,
        'path' : (_imageName == null) ? '' : 'posts/' + _imageName,
        'comments': [],
        'likes': [],
        'favorites': []
      });
      if (ref != null) {
        return true;
      }
    } catch (e) {
      print('Case ${e.message} is not yet implemented');
      return false;
    }
    return false;
  }
}

