import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/movie/movie_bloc.dart';
import 'package:movie/movie_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

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
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MovieLoaded) {
          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7, 
            ),
            itemCount: state.movies.length + 1,
            itemBuilder: (context, index) {
              if (index < state.movies.length) {
                final movie = state.movies[index];
                return MovieCard(movie: movie);
              } else {
                return state.hasReachedMax
                    ? const SizedBox()
                    : const Center(child: CircularProgressIndicator());
              }
            },
          );
        }

        if (state is MovieError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}

class MovieCard extends StatelessWidget {
  final dynamic movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MovieDetailPage(movie: movie)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border),
                        color: Colors.red,
                        onPressed: () {},
                      ),
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
