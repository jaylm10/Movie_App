import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:movie/model/movie.dart';
import 'package:dio/dio.dart';

/// Singleton Dio instance
class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Linux; Android 14.0; en-US)',
          'Accept': 'application/json',
          'Accept-Encoding': 'gzip, deflate',
        },
      ),
    );

    // Add interceptors only once
    if (_dio.interceptors.isEmpty) {
      _dio.interceptors.add(RateLimitInterceptor());
    }
  }

  Dio get dio => _dio;
}

final dio = DioClient().dio;

class RateLimitInterceptor extends Interceptor {
  static DateTime? _lastRequestTime;
  static const Duration minDelay = Duration(milliseconds: 1000);
  static int _activeRequests = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    _activeRequests++;
    final now = DateTime.now();
    
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = now.difference(_lastRequestTime!);
      if (timeSinceLastRequest < minDelay) {
        final delayMs = minDelay.inMilliseconds - timeSinceLastRequest.inMilliseconds;
        debugPrint('⏳ Rate limit: Waiting ${delayMs}ms (${_activeRequests} active requests)');
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }
    
    _lastRequestTime = DateTime.now();
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _activeRequests--;
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _activeRequests--;
    return super.onError(err, handler);
  }
}

class MovieApiService {
  static const int maxRetries = 3;

  Future<List<Movie>> fetchTrending(int page) async {
    int retryCount = 0;
    
    while (retryCount < maxRetries) {
      try {
        debugPrint('📡 Fetching page $page (attempt ${retryCount + 1}/$maxRetries)');
        
        final response = await dio.get(
          'https://api.themoviedb.org/3/trending/movie/day',
          queryParameters: {
            'api_key': dotenv.env['TMDB_API_KEY'],
            'page': page,
          },
        ).timeout(
          const Duration(seconds: 20),
          onTimeout: () => throw DioException(
            requestOptions: RequestOptions(path: ''),
            message: 'Request timeout',
            type: DioExceptionType.receiveTimeout,
          ),
        );

        if (response.statusCode == 200) {
          final data = response.data;
          List result = data['results'] ?? [];
          debugPrint('✅ Page $page: ${result.length} movies loaded');
          return result.map((e) => Movie.fromJson(e)).toList();
        } else {
          throw Exception("API returned ${response.statusCode}");
        }
      } on DioException catch (e) {
        retryCount++;
        debugPrint('❌ DioException on attempt $retryCount: ${e.type}');
        
        // Retry on transient errors
        if (_isRetryable(e.type) && retryCount < maxRetries) {
          final delaySeconds = (retryCount * 2); // Exponential: 2s, 4s
          debugPrint('   Retrying in ${delaySeconds}s...');
          await Future.delayed(Duration(seconds: delaySeconds));
          continue;
        }
        
        throw _formatError(e);
      } catch (e) {
        debugPrint('❌ Unexpected error: $e');
        throw Exception("Error: $e");
      }
    }
    
    throw Exception("Failed after $maxRetries attempts");
  }

  bool _isRetryable(DioExceptionType type) {
    return type == DioExceptionType.connectionError ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.connectionTimeout;
  }

  Exception _formatError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception("⏱️ Connection timeout - retry in a moment");
      case DioExceptionType.receiveTimeout:
        return Exception("⏱️ Server response timeout - retry in a moment");
      case DioExceptionType.badResponse:
        return Exception("Server error: ${e.response?.statusCode}");
      case DioExceptionType.connectionError:
        return Exception("🌐 Connection issue - retrying...");
      default:
        return Exception("Network error: ${e.message}");
    }
  }
}
