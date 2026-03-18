import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie/auth_gate.dart';
import 'package:movie/bloc/auth/auth_bloc.dart';
import 'package:movie/bloc/movie/movie_bloc.dart';
import 'package:movie/repository/movie_repo.dart';
import 'package:movie/service/api_service.dart';
import 'package:movie/service/auth_service.dart';

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
      ],
      child: MaterialApp(title: 'Movie', home: AuthGate()),
    );
  }
}
