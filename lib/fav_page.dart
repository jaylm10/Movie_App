
import 'package:flutter/material.dart';

class FavPage extends StatelessWidget {
  const FavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: const Center(
        child: Text("Favorite Movies Here"),
      ),
    );
  }
}