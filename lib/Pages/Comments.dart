import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/Pages/SinglePost.dart';
import 'package:flutter_module/Utils/FirebaseInteractions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Comments extends StatefulWidget {
  final DocumentSnapshot post;
  Comments({Key key, @required this.post}) : super(key: key);
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  String _email = "";
  DocumentSnapshot _postInfo;
  @override
  void initState() {
    getInfo();
    super.initState();
  }

  void getInfo() async {
    String email = await getEmail();
    setState(() {
      _email = email;
      _postInfo = this.widget.post;
    });
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  void refresh() async {
    DocumentSnapshot tmp = await FirebaseInteractions.getDocument("posts", this.widget.post.id);
    setState(() {
      _postInfo = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    FullScreenDialog _myDialog = new FullScreenDialog(postInfo: _postInfo, email: _email, callback: refresh,);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF37474F),
        child: Icon(Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) => _myDialog,
            fullscreenDialog: true,
          ));
        },
      ),
      body: (_postInfo == null ? Center(
        child: CircularProgressIndicator(backgroundColor: Colors.white,),
      ) : ListView.separated(
          itemCount: _postInfo["comments"].length + 1,
          separatorBuilder: (context, index) {
            if (index == 0)
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
                child: Divider(color: Colors.white,),
              );
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.005,
            );
          },
          itemBuilder: (context, index) {
            if (index == 0)
              return SinglePost(postInfo: _postInfo, email: _email,);
            index -= 1;
            Map<String, dynamic> post = _postInfo["comments"][index];
            return Card(
              color: Colors.transparent,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),),
                      Icon(Icons.person, color: Colors.white,),
                      Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),),
                      Text(post["author"], style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(post["message"], style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05))
                      )
                  ),
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),),
                ],
              ),
            );
          })),
    );
  }
}

class FullScreenDialog extends StatefulWidget {
  String _content = "Say something nice !";
  final String email;
  final DocumentSnapshot postInfo;
  final Function callback;
  FullScreenDialog({Key key, @required this.email, @required this.postInfo, @required this.callback}) : super(key: key);

  @override
  FullScreenDialogState createState() => new FullScreenDialogState();
}

class FullScreenDialogState extends State<FullScreenDialog> {
  TextEditingController _contentController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Write your comment"),
          backgroundColor: Colors.transparent,
        ),
        body: new Padding(child: new ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),),
            new TextField(
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[500]),
                  hintText: "Say something nice !",
                  fillColor: Colors.transparent),
              maxLines: 4,
              controller: _contentController,
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),),
            new Row(
              children: <Widget>[
                new Expanded(
                    child: new RaisedButton(
                      onPressed: () async {
                        widget._content = _contentController.text;
                        List<dynamic> newComments = this.widget.postInfo["comments"];
                        newComments.add({
                          "author": this.widget.email,
                          "message": _contentController.text
                        });
                        await FirebaseInteractions.updateDocument("posts", this.widget.postInfo.id, {
                          "comments": newComments
                        });
                        Navigator.pop(context);
                        await this.widget.callback();
                      },
                      color: Colors.transparent,
                      child: new Text("Send"),
                    )
                ),
              ],
            ),
          ],
        ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),)
    );
  }


}
