import 'package:flutter/material.dart';
import 'package:project/productpage.dart';
import 'package:project/profilepage.dart';
import 'package:project/user.dart';

class MainPage extends StatefulWidget {
  final User user;
  const MainPage({Key? key,  required this.user}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Home";

  @override
  void initState() {
    super.initState();
    tabchildren =  [
      ProductPage(user: widget.user),
      ProfilePage(user: widget.user),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
          selectedItemColor: Colors.grey[500],
          unselectedItemColor: Colors.grey[400],
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: ("Home")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_sharp), label: ("Profile")),
          ],
      ),           
    );
  }

void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "Home";
      }
      if (_currentIndex == 1) {
        maintitle = "Profile";
      }
    });
  }
}
