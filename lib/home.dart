import 'package:flutter/material.dart';
import 'package:movie/category.dart';
import 'package:movie/homePage.dart';
import 'package:movie/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

   late TabController _tabController;

   @override
  void initState() {
    
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: TabBarView(
        controller: _tabController,
        children: const [
        HomePage(),
        Category(),
        ProfilePage(),
      ]),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home),     text: "Home"),
            Tab(icon: Icon(Icons.category), text: "Category"),
            Tab(icon: Icon(Icons.person),   text: "Profile"),
          ]),
      ),
    );
  }
}
