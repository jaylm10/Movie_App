import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:movie/model/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'fav_movie_event.dart';
part 'fav_movie_state.dart';

class FavMovieBloc extends Bloc<FavMovieEvent, FavMovieState> {
  static const String _favMoviesKey = 'fav_movies';

  FavMovieBloc() : super(FavMovieInitial()) {
    on<LoadSavedFavorites>(_onLoadSavedFavorites);
    on<AddMovie>(_onAddMovie);
    on<RemoveMovie>(_onRemoveMovie);
    on<ToggleMovie>(_onToggleMovie);

    add(LoadSavedFavorites());
  }

  List<Movie> _currentMovies() {
    if (state is FavMovieLoaded) {
      return List<Movie>.from((state as FavMovieLoaded).movies);
    }
    return [];
  }

  
  Future<void> _onLoadSavedFavorites(
    LoadSavedFavorites event,
    Emitter<FavMovieState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedMovies = prefs.getStringList(_favMoviesKey) ?? [];

      final movies = encodedMovies
          .map((movieJson) => Movie.fromMap(jsonDecode(movieJson)))
          .toList();

      emit(FavMovieLoaded(movies));
    } catch (_) {
      emit(FavMovieLoaded([]));
    }
  }

  Future<void> _saveFavorites(List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedMovies = movies
        .map((movie) => jsonEncode(movie.toMap()))
        .toList();
    await prefs.setStringList(_favMoviesKey, encodedMovies);
  }

  Future<void> _onAddMovie(AddMovie event, Emitter<FavMovieState> emit) async {
    final movies = _currentMovies();
    final alreadyExists = movies.any((movie) => movie.id == event.movie.id);

    if (!alreadyExists) {
      movies.add(event.movie);
      await _saveFavorites(movies);
      emit(FavMovieLoaded(movies));
      return;
    }

    await _saveFavorites(movies);
    emit(FavMovieLoaded(movies));
  }

  Future<void> _onRemoveMovie(
    RemoveMovie event,
    Emitter<FavMovieState> emit,
  ) async {
    final movies = _currentMovies();
    movies.removeWhere((movie) => movie.id == event.movie.id);
    await _saveFavorites(movies);
    emit(FavMovieLoaded(movies));
  }

  Future<void> _onToggleMovie(
    ToggleMovie event,
    Emitter<FavMovieState> emit,
  ) async {
    final movies = _currentMovies();
    final alreadyExists = movies.any((movie) => movie.id == event.movie.id);

    if (alreadyExists) {
      movies.removeWhere((movie) => movie.id == event.movie.id);
    } else {
      movies.add(event.movie);
    }

    await _saveFavorites(movies);
    emit(FavMovieLoaded(movies));
  }

  
}
