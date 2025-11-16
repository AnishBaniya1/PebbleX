import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pebblex_app/views/home/home_page.dart';
import 'package:pebblex_app/views/setting/profilepage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // Create pages once, not on every rebuild
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    //Initialize pages once
    _pages = [const HomePage(), const Profilepage()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Use IndexedStack to preserve page state
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        index: _currentIndex,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white),
          // Icon(Icons.shopping_bag_outlined, color: Colors.white),
          Icon(Icons.person_outline, color: Colors.white),
        ],
      ),
    );
  }
}

