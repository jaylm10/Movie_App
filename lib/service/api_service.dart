import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie/model/movie.dart';
import 'package:dio/dio.dart';

 final dio = Dio(
    BaseOptions(
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'application/json, text/plain, */*',
        'Accept-Language': 'en-US,en;q=0.9',
        'Connection': 'keep-alive',
      },
    ),
  );

class MovieApiService {

  Future<List<Movie>> fetchTrending(int page)async{

    final respose = await dio.get('https://api.themoviedb.org/3/trending/movie/week?api_key=${dotenv.env['TMDB_API_KEY']}&page=$page');

    if(respose.statusCode == 200){
      final data = jsonDecode(respose.data);
      List result = data['result'];
      return result.map((e)=>Movie.fromJson(e)).toList();
    }else{
      throw Exception("Failed to fetch movies");
    }


  }

}
