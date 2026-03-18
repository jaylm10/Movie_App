import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  final dynamic movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title,style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
        
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            
            Image.network(
              "https://image.tmdb.org/t/p/w500${movie.posterPath}",
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🎬 Title
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),
                  

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Text(
                        " ${movie.rating.toStringAsFixed(1)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 📝 Overview
                  const Text(
                    "Overview",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    movie.overview ?? "No description available",
                    style: const TextStyle(color: Colors.black87),
                  ),

                  const SizedBox(height: 16),

                  // 🌐 Language
                  Row(
                    children: [
                      const Text("Language: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(movie.lan ?? "N/A"),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // 📅 Release Date
                  Row(
                    children: [
                      const Text("Release Date: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(movie.rel_date ?? "N/A"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}