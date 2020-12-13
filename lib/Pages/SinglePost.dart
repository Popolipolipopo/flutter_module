import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SinglePost extends StatefulWidget {
  final QueryDocumentSnapshot postInfo;
  SinglePost({Key key, @required this.postInfo}) : super(key: key);
  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {

  @override
  void initState() {
    getFullPostInfo();
    super.initState();
  }

  void getFullPostInfo() async {

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: Column(
        children: [
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),),
              Icon(Icons.person, color: Colors.white,),
              Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),),
              Text(this.widget.postInfo["author"], style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),),
          Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(this.widget.postInfo["message"], style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05))
              )
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),),
          (this.widget.postInfo.data()["path"] == null || this.widget.postInfo.data()["path"].isEmpty ? Container() :
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Card(
              child: Image.network("https://firebasestorage.googleapis.com/v0/b/flutter-6744b.appspot.com/o/" + Uri.encodeComponent(this.widget.postInfo.data()["path"]) + "?alt=media&token=43ca32a6-625a-4fc5-a9f0-5c95e056392b" + DateTime.now().millisecondsSinceEpoch.toString()),
            ),
          )),
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
  }
}
