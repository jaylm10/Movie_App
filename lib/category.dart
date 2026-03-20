import 'package:flutter/material.dart';
import 'package:movie/genremovie_page.dart';
import 'package:movie/model/genre.dart';


const List<Genre> genreList = [
  Genre(id: 28,    name: 'Action'),
  Genre(id: 12,    name: 'Adventure'),
  Genre(id: 16,    name: 'Animation'),
  Genre(id: 35,    name: 'Comedy'),
  Genre(id: 80,    name: 'Crime'),
  Genre(id: 99,    name: 'Documentary'),
  Genre(id: 18,    name: 'Drama'),
  Genre(id: 10751, name: 'Family'),
  Genre(id: 14,    name: 'Fantasy'),
  Genre(id: 36,    name: 'History'),
  Genre(id: 27,    name: 'Horror'),
  Genre(id: 10402, name: 'Music'),
  Genre(id: 9648,  name: 'Mystery'),
  Genre(id: 10749, name: 'Romance'),
  Genre(id: 878,   name: 'Science Fiction'),
  Genre(id: 10770, name: 'TV Movie'),
  Genre(id: 53,    name: 'Thriller'),
  Genre(id: 10752, name: 'War'),
  Genre(id: 37,    name: 'Western'),
];

const List<Color> genreColors = [
  Color(0xFFE53935), Color(0xFF8E24AA), Color(0xFF1E88E5), Color(0xFF43A047),
  Color(0xFFFF6F00), Color(0xFF00897B), Color(0xFFD81B60), Color(0xFF6D4C41),
  Color(0xFF3949AB), Color(0xFF00ACC1), Color(0xFF7CB342), Color(0xFFEF6C00),
  Color(0xFF5E35B1), Color(0xFFEC407A), Color(0xFF0288D1), Color(0xFF558B2F),
  Color(0xFFF4511E), Color(0xFF546E7A), Color(0xFF6D4C41),
];

const List<IconData> genreIcons = [
  Icons.local_fire_department,    Icons.explore,          Icons.animation,
  Icons.sentiment_very_satisfied, Icons.gavel,            Icons.videocam,
  Icons.theater_comedy,           Icons.family_restroom,  Icons.auto_fix_high,
  Icons.history_edu,              Icons.nights_stay,      Icons.music_note,
  Icons.search,                   Icons.favorite,         Icons.rocket_launch,
  Icons.tv,                       Icons.front_hand,       Icons.military_tech,
  Icons.landscape,
];

class Category extends StatefulWidget  {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> with AutomaticKeepAliveClientMixin {


  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: genreList.length,
          itemBuilder: (context, index) {
            return GenreCard(
              genre: genreList[index],       // ← pass the whole Genre object
              color: genreColors[index],
              icon:  genreIcons[index],
            );
          },
        ),
      ),
    );
  }
}

class GenreCard extends StatelessWidget {
  final Genre    genre;           // ← Genre object instead of just String name
  final Color    color;
  final IconData icon;

  const GenreCard({
    super.key,
    required this.genre,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GenreMoviesPage(genre: genre),  // ← now works ✅
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 42),
            const SizedBox(height: 12),
            Text(
              genre.name,                    // ← genre.name instead of name
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}