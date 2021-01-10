import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/Utils/FirebaseInteractions.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/src/foundation/constants.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'Comments.dart';

class SinglePost extends StatefulWidget {
  final DocumentSnapshot postInfo;
  final String email;
  SinglePost({Key key, @required this.postInfo, @required this.email}) : super(key: key);
  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {

  DocumentSnapshot _postInfo;
  String _urlFirestore = "";
  AudioCache _audioCache = AudioCache();

  @override
  void initState() {
    super.initState();
    _postInfo = this.widget.postInfo;
    getConfig();
    if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }
    if (Platform.isIOS) {
      if (_audioCache.fixedPlayer != null) {
        _audioCache.fixedPlayer.startHeadlessService();
      }
    }
  }

  void getConfig() async {
    Map<String, dynamic> config = jsonDecode(await rootBundle.loadString('assets/config.json'));
    setState(() {
      _urlFirestore = config["firestore_url"];
    });
  }

  void refresh() async {
    DocumentSnapshot tmp = await FirebaseInteractions.getDocument("posts", this.widget.postInfo.id);
    setState(() {
      _postInfo = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_urlFirestore.isEmpty) {
      return CircularProgressIndicator(backgroundColor: Colors.white,);
    }
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
          Card(
            child: Image.network(
                  _urlFirestore
                  + Uri.encodeComponent(this.widget.postInfo.data()["path"])
                  + "?alt=media",
              fit: BoxFit.fitWidth,
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
            ),
          )),
          (this.widget.postInfo.data()["path"] == null || this.widget.postInfo.data()["path"].isEmpty ? Container() : Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(icon: (_postInfo.data()["likes"].contains(this.widget.email) ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
                color: (_postInfo.data()["likes"].contains(this.widget.email) ? Colors.red : null),
                onPressed: () async {
                  Vibration.vibrate();
                  _audioCache.play('like.mp3');
                  if (_postInfo.data()["likes"].contains(this.widget.email)) {
                    List<dynamic> tmp = _postInfo.data()["likes"];
                    tmp.remove(this.widget.email);
                    await FirebaseInteractions.updateDocument("posts", this.widget.postInfo.id, {
                      "likes": tmp
                    });
                    refresh();
                  } else {
                    List<dynamic> tmp = _postInfo.data()["likes"];
                    tmp.add(this.widget.email);
                    await FirebaseInteractions.addFieldToArray("posts", this.widget.postInfo.id, "likes", this.widget.email);
                    refresh();
                  }
                },),
              IconButton(icon: (_postInfo.data()["favorites"].contains(this.widget.email) ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border)),
                color: (_postInfo.data()["favorites"].contains(this.widget.email) ? Colors.green : null),
                onPressed: () async {
                  Vibration.vibrate();
                  _audioCache.play('bookmark.mp3');
                  if (_postInfo.data()["favorites"].contains(this.widget.email)) {
                    List<dynamic> tmp = _postInfo.data()["favorites"];
                    tmp.remove(this.widget.email);
                    await FirebaseInteractions.updateDocument("posts", this.widget.postInfo.id, {
                      "favorites": tmp
                    });
                    refresh();
                  } else {
                    List<dynamic> tmp = _postInfo.data()["favorites"];
                    tmp.add(this.widget.email);
                    await FirebaseInteractions.addFieldToArray("posts", this.widget.postInfo.id, "favorites", this.widget.email);
                    refresh();
                  }
                },),
              Row(
                children: [
                  IconButton(icon: (_postInfo.data()["comments"].length != 0 ? Icon(Icons.mode_comment) : Icon(Icons.mode_comment_outlined)),
                    color: (_postInfo.data()["comments"].length != 0 ? Colors.blue : null), onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Comments(post: _postInfo),),);
                    refresh();
                    },
                  ),
                  Text(_postInfo.data()["comments"].length.toString())
                ],
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),),
        ],
      ),
    );
  }
}
