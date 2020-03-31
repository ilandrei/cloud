import 'package:flutter/material.dart';
import 'package:mentorship/profile_screen.dart';
import './services/authservice.dart';
import './teach_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.logoutCallback, this.userId});

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tabIndex;
  List<Widget> listScreens;
  @override
  void initState() {
    super.initState();
    tabIndex = 0;
    listScreens = [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.black, Colors.black87],
          ),
        ),
      ),
      TeachWidget(
        auth: widget.auth,
      ),
      Container(
        color: Colors.green,
        child: ProfileScreen(
          auth: widget.auth,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listScreens[tabIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.yellow[300],
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.black,
          currentIndex: tabIndex,
          onTap: (int index) {
            setState(() {
              tabIndex = index;
              print(listScreens[tabIndex]);
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              title: Text('Explore'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              title: Text('Teach'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
          ]),
    );
  }
}
