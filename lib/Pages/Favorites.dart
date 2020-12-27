import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/Utils/FirebaseInteractions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SinglePost.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  List<DocumentSnapshot> _posts = List<DocumentSnapshot>();
  String _email = "";

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  void getPosts() async {
    String email = await getEmail();
    List<DocumentSnapshot> posts = await FirebaseInteractions.getDocumentWithQueryContains("posts", "favorites", email);
    setState(() {
      _posts = posts;
      _email = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text("FAVORITES"),
      ),
      body: ListView.separated(
          itemCount: _posts.length,
          separatorBuilder: (context, index) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            );
          },
          itemBuilder: (context, index) {
            return SinglePost(postInfo: _posts[index], email: _email,);
          }),
    );
  }
}
