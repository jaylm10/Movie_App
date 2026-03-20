part of 'movie_bloc.dart';

@immutable
sealed class MovieState {}

final class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final bool hasReachedMax;
  final bool isLoadingMore;

  MovieLoaded(
    this.movies, {
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });
}

class MovieError extends MovieState {
  final String message;

  MovieError(this.message);
}