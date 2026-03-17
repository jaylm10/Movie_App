import 'package:movie/model/movie.dart';
import 'package:movie/service/api_service.dart';

class MovieRepository {
  final MovieApiService api;

  MovieRepository(this.api);

  Future<List<Movie>> getTrending(int page) {
    return api.fetchTrending(page);
  }
}