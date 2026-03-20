import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/favMovie/fav_movie_bloc.dart';
import 'package:movie/bloc/movie/movie_bloc.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/movie_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _onRefresh() async {
    final movieBloc = context.read<MovieBloc>();
    movieBloc.add(FetchMovies(forceRefresh: true));
    await movieBloc.stream.firstWhere((state) => state is! MovieLoading);
  }

  @override
  void initState() {
    super.initState();

    context.read<MovieBloc>().add(FetchMovies());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<MovieBloc>().add(LoadMoreMovies());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movies',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MovieLoaded) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: Stack(
                children: [
                  GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return MovieCard(movie: movie);
                    },
                  ),
                  if (state.isLoadingMore)
                    const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 16,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            );
          }

          if (state is MovieError) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(child: Text(state.message)),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movie: movie),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: BlocBuilder<FavMovieBloc, FavMovieState>(
                      builder: (context, state) {
                        final favorites = state is FavMovieLoaded
                            ? state.movies
                            : <Movie>[];
                        final isFavorite = favorites.any(
                          (item) => item.id == movie.id,
                        );

                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                            color: Colors.red,
                            onPressed: () {
                              context.read<FavMovieBloc>().add(
                                ToggleMovie(movie),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  // Movie Name
                  Expanded(
                    child: Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  const SizedBox(width: 6),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(
                        movie.rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12),
                      ),
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
