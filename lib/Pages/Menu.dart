import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> pages = [
    ['Profile', '/profile', Icons.person],
    ['Favorites', '/fav', Icons.bookmark],
    ['Sign out', '/deco', Icons.exit_to_app],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              (pages[index][0] == 'Sign out') ?
              signOut(context) :
              Navigator.pushNamed(context, pages[index][1]);
            },
            child: Card(
              color: Color(0xFF3A4048),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      pages[index][2],
                      color: Theme.of(context).accentColor
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(pages[index][0], style: TextStyle(fontSize: 22.0),),
                  ),
                ],
              )
            ),
          );
        },
      )
    );
  }

  void unsaveEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", "");
  }

  void signOut(context) {
    print("DECO");
    unsaveEmail();
    auth.signOut().then(
            (value) => Navigator.pushReplacementNamed(context, '/deco')
    );
  }
}
