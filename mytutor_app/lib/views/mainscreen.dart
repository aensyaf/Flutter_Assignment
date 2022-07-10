import 'package:flutter/material.dart';
import 'package:mytutor_app/views/subjectpage.dart';
import 'package:mytutor_app/views/favpage.dart';
import 'package:mytutor_app/views/profilepage.dart';
import 'package:mytutor_app/views/subspage.dart';
import 'package:mytutor_app/views/tutorpage.dart';

import '../models/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key,
    required this.user,}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Subjects";

  @override
  void initState() {
    super.initState();
    tabchildren =  [
      SubjectPage(user: widget.user),
      TutorPage(),
      SubsPage(),
      FavPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: 
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: tabchildren.elementAt(_currentIndex),
        ),
        
        bottomNavigationBar:
          Theme(
            data: ThemeData(
            canvasColor: const Color.fromARGB(255,155,36,36),
           ),
          child: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.subject),
                label: "Subjects",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: "Tutors"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.subscriptions),
                label: "Subscribe"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Favourite"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: "Profile"
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void onTabTapped(int index) {
      setState(() {
        _currentIndex = index;
        if(_currentIndex==0) {
          maintitle = "Subjects";
        }
        if(_currentIndex==1) {
          maintitle = "Tutors";
        }
        if(_currentIndex==2) {
          maintitle = "Subscribe";
        }
        if(_currentIndex==3) {
          maintitle = "Favourites";
        }
        if(_currentIndex==4) {
          maintitle = "Profile";
        }
      });
    }
    
}