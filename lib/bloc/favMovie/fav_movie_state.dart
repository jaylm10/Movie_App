part of 'fav_movie_bloc.dart';

@immutable
sealed class FavMovieState {}

final class FavMovieInitial extends FavMovieState {}

final class FavMovieLoaded extends FavMovieState {
	final List<Movie> movies;

	FavMovieLoaded(this.movies);
}
