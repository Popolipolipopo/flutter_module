import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/Utils/FirebaseInteractions.dart';

class SinglePost extends StatefulWidget {
  final QueryDocumentSnapshot postInfo;
  final String email;
  SinglePost({Key key, @required this.postInfo, @required this.email}) : super(key: key);
  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {

  Map<String, dynamic> _postInfo = Map<String, dynamic>();

  @override
  void initState() {
    _postInfo = this.widget.postInfo.data();
    super.initState();
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
              IconButton(icon: (_postInfo["likes"].contains(this.widget.email) ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
                color: (_postInfo["likes"].contains(this.widget.email) ? Colors.red : null),
                onPressed: () {
                  if (_postInfo["likes"].contains(this.widget.email)) {
                    List<dynamic> tmp = _postInfo["likes"];
                    tmp.remove(this.widget.email);
                    FirebaseInteractions.updateDocument("posts", this.widget.postInfo.id, {
                      "likes": tmp
                    });
                    setState(() {
                      _postInfo["likes"] = tmp;
                    });
                  } else {
                    List<dynamic> tmp = _postInfo["likes"];
                    tmp.add(this.widget.email);
                    FirebaseInteractions.addFieldToArray("posts", this.widget.postInfo.id, "likes", this.widget.email);
                    setState(() {
                      _postInfo["likes"] = tmp;
                    });
                  }
                },),
              IconButton(icon: (_postInfo["favorites"].contains(this.widget.email) ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border)),
                color: (_postInfo["favorites"].contains(this.widget.email) ? Colors.green : null), onPressed: () {
                  if (_postInfo["favorites"].contains(this.widget.email)) {
                    List<dynamic> tmp = _postInfo["favorites"];
                    tmp.remove(this.widget.email);
                    FirebaseInteractions.updateDocument("posts", this.widget.postInfo.id, {
                      "favorites": tmp
                    });
                    setState(() {
                      _postInfo["favorites"] = tmp;
                    });
                  } else {
                    List<dynamic> tmp = _postInfo["favorites"];
                    tmp.add(this.widget.email);
                    FirebaseInteractions.addFieldToArray("posts", this.widget.postInfo.id, "favorites", this.widget.email);
                    setState(() {
                      _postInfo["favorites"] = tmp;
                    });
                  }
                },),
              IconButton(icon: Icon(Icons.mode_comment_outlined), onPressed: () {
                FirebaseInteractions.addFieldToArray("posts", this.widget.postInfo.id, "comments", this.widget.email);
              },),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),),
        ],
      ),
    );
  }
}
