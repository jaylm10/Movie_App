part of 'fav_movie_bloc.dart';

@immutable
sealed class FavMovieEvent {}

final class LoadSavedFavorites extends FavMovieEvent {}

final class ToggleMovie extends FavMovieEvent {
  final Movie movie;

  ToggleMovie(this.movie);
}

final class AddMovie extends FavMovieEvent {
  final Movie movie;

  AddMovie(this.movie);
}

final class RemoveMovie extends FavMovieEvent {
  final Movie movie;

  RemoveMovie(this.movie);
}