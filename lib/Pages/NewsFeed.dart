import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/Utils/FirebaseInteractions.dart';

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
            return Card(
              color: Colors.transparent,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),),
                      Icon(Icons.person, color: Colors.white,),
                      Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),),
                      Text(_posts[index]["author"], style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_posts[index]["message"], style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05))
                      )
                  ),
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.favorite_border),
                        Icon(Icons.bookmark_border),
                        Icon(Icons.mode_comment_outlined),
                      ],
                    ),
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),),
                ],
              ),
            );
          }),
    );
  }
}
