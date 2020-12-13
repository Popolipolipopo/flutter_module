import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/Utils/FirebaseInteractions.dart';

import 'SinglePost.dart';

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {

  List<QueryDocumentSnapshot> _posts = List<QueryDocumentSnapshot>();

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  void getPosts() async {
    List<QueryDocumentSnapshot> posts = await FirebaseInteractions.getDocumentsList("posts");
    setState(() {
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    int sepCount = 0;
    return Scaffold(
      body: ListView.builder(
          itemCount: _posts.length * 2,
          itemBuilder: (context, index) {
            if (index % 2 == 0) {
              sepCount += 1;
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.005,
              );
            }
            index -= sepCount;
            return SinglePost(postInfo: _posts[index]);
          }),
    );
  }
}
