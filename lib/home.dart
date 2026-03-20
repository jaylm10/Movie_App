import 'package:flutter/material.dart';
import 'package:movie/category.dart';
import 'package:movie/homePage.dart';
import 'package:movie/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

   int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const Category(),
    const ProfilePage(),
  ];

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Category",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],),
    );
  }
}
