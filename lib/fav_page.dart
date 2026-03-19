
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/favMovie/fav_movie_bloc.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/movie_detail_page.dart';

class FavPage extends StatelessWidget {
  const FavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: BlocBuilder<FavMovieBloc, FavMovieState>(
        builder: (context, state) {
          final favorites = state is FavMovieLoaded ? state.movies : <Movie>[];

          if (favorites.isEmpty) {
            return const Center(
              child: Text("No favorite movies yet"),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: favorites.length,
            separatorBuilder: (_,_) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final movie = favorites[index];

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: movie),
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.white,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(movie.rating.toStringAsFixed(1)),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    context.read<FavMovieBloc>().add(RemoveMovie(movie));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}