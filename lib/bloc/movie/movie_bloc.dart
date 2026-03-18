import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/repository/movie_repo.dart';

part 'movie_event.dart';
part 'movie_state.dart';


class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;

  int page = 1;
  bool isFetching = false;
  int totalPage = 500;

  MovieBloc(this.repository) : super(MovieInitial()) {
    on<FetchMovies>(_fetchMovies);
    on<LoadMoreMovies>(_loadMoreMovies);
  }

  Future<void> _fetchMovies(
    FetchMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());

    try {
      final movies = await repository.getTrending(page);
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  Future<void> _loadMoreMovies(
    LoadMoreMovies event,
    Emitter<MovieState> emit,
  ) async {
    if (state is MovieLoaded && !isFetching) {
      final currentState = state as MovieLoaded;

      if (currentState.hasReachedMax) return;

      isFetching = true;
      page++;

      try {
        final newMovies = await repository.getTrending(page);

        if (page>=totalPage) {
          emit(MovieLoaded(currentState.movies, hasReachedMax: true));
        } else {
          emit(
            MovieLoaded(
              [...currentState.movies, ...newMovies],
              hasReachedMax: false,
            ),
          );
        }
      } catch (e) {
        emit(MovieError(e.toString()));
      }

      isFetching = false;
    }
  }
}
