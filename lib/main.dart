import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie/auth_gate.dart';
import 'package:movie/bloc/auth/auth_bloc.dart';
import 'package:movie/bloc/favMovie/fav_movie_bloc.dart';
import 'package:movie/bloc/movie/movie_bloc.dart';
import 'package:movie/bloc/profile/profile_bloc.dart';
import 'package:movie/repository/movie_repo.dart';
import 'package:movie/service/api_service.dart';
import 'package:movie/service/auth_service.dart';
import 'package:movie/service/profile_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (error) {
    debugPrint('Skipping .env load: $error');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(authService: AuthService())),
        BlocProvider(create: (context) => MovieBloc(MovieRepository(MovieApiService()))),
        BlocProvider(create: (context) => ProfileBloc(ProfileService())),
        BlocProvider(create: (context) => FavMovieBloc()),

      ],
      child: MaterialApp(title: 'Movie', home: AuthGate()),
    );
  }
}
