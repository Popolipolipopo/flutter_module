import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/Utils/FirebaseInteractions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SinglePost.dart';

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {

  List<QueryDocumentSnapshot> _posts = List<QueryDocumentSnapshot>();
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
    List<QueryDocumentSnapshot> posts = await FirebaseInteractions.getDocumentsList("posts");
    String email = await getEmail();
    setState(() {
      _posts = posts;
      _email = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
