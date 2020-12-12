import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/Pages/Page1.dart';
import 'package:flutter_module/Pages/Post.dart';
import 'package:flutter_module/Pages/Menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<String> _titles = ['WAVE', 'POST', 'MENU'];
  List<Widget> _tabs;

  @override
  Widget build(BuildContext context) {
    _tabs = [
      Page1(),
      Post(onClick: (value) { setState(() {selectedIndex = value;});}),
      Menu()];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[selectedIndex]),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          Container(
            padding: EdgeInsets.all(5),
            child: RawMaterialButton(
              child: Icon(Icons.send, color: Theme.of(context).accentColor),
              fillColor: Color(0xFF3A4048),
//              padding: EdgeInsets.all(10.0),
              shape: CircleBorder(),
              onPressed: () {},
            )
          )
        ],
      ),
      body: Center(
        child: _tabs.elementAt(selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          boxShadow: <BoxShadow> [
            BoxShadow(
              color: Colors.black,
              blurRadius: 1,
            )
          ]
        ),
        child: _navigationBar(),
      ),
    );
  }

  Widget _navigationBar() {
    return (
        Container(
          padding: EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          ),
          child: CustomNavigationBar(
            iconSize: 26.0,
            selectedColor: Theme.of(context).primaryColor,
            strokeColor: Color(0x30040307),
            unSelectedColor: Color(0xffacacac),
            backgroundColor: Theme.of(context).backgroundColor,
            items: [
              CustomNavigationBarItem(
                icon: Icon(Icons.home),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.add_circle),
              ),
              CustomNavigationBarItem(
                icon: Icon(Icons.format_list_bulleted),
              ),
            ],
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        )
    );
  }
}
