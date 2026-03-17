class Movie {
  final String title;
  final String posterPath;
  final double rating;
  final String overview;
  final String lan;
  final String rel_date;

  Movie({
    required this.title,
    required this.posterPath,
    required this.rating,
    required this.overview,
    required this.lan,
    required this.rel_date,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      overview: json['overview'] ?? '',
      lan: json['original_language'] ?? '',
      rel_date: json['release_date'] ?? '',
    );
  }
}
