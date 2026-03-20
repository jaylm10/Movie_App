part of 'movie_bloc.dart';

@immutable
sealed class MovieEvent {}

class FetchMovies extends MovieEvent {
	final bool forceRefresh;

	FetchMovies({this.forceRefresh = false});
}

class LoadMoreMovies extends MovieEvent {}