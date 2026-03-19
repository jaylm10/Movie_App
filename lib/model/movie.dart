class Movie {
  final int id;
  final String title;
  final String posterPath;
  final double rating;
  final String overview;
  final String lan;
  final String rel_date;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.rating,
    required this.overview,
    required this.lan,
    required this.rel_date,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      overview: json['overview'] ?? '',
      lan: json['original_language'] ?? '',
      rel_date: json['release_date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'rating': rating,
      'overview': overview,
      'lan': lan,
      'rel_date': rel_date,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      posterPath: map['posterPath'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      overview: map['overview'] ?? '',
      lan: map['lan'] ?? '',
      rel_date: map['rel_date'] ?? '',
    );
  }
}
