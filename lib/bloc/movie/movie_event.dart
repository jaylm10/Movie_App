part of 'movie_bloc.dart';

@immutable
sealed class MovieEvent {}

class FetchMovies extends MovieEvent {}

class LoadMoreMovies extends MovieEvent {}