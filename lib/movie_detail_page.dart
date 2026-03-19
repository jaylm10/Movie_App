import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/favMovie/fav_movie_bloc.dart';
import 'package:movie/model/movie.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title,style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
        actions: [
          BlocBuilder<FavMovieBloc, FavMovieState>(
            builder: (context, state) {
              final favorites = state is FavMovieLoaded ? state.movies : <Movie>[];
              final isFavorite = favorites.any((item) => item.id == movie.id);

              return IconButton(
                onPressed: () {
                  context.read<FavMovieBloc>().add(ToggleMovie(movie));
                },
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                color: Colors.white,
              );
            },
          ),
        ],
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
                    movie.overview,
                    style: const TextStyle(color: Colors.black87),
                  ),

                  const SizedBox(height: 16),

                  // 🌐 Language
                  Row(
                    children: [
                      const Text("Language: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(movie.lan),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // 📅 Release Date
                  Row(
                    children: [
                      const Text("Release Date: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(movie.rel_date),
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