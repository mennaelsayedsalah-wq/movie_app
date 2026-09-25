import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';

class TmdbService {
  static const String baseUrl = 'https://api.themoviedb.org/3';

  final String apiKey = const String.fromEnvironment(
    'TMDB_API_KEY',
  );

  Future<List<Movie>> getMovies(String endpoint) async {
    final uri = Uri.parse(
      '$baseUrl$endpoint?api_key=$apiKey&language=en-US',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('TMDB request failed');
    }

    final data = jsonDecode(response.body);

    if (data is! Map || data['results'] is! List) {
      throw Exception('Invalid TMDB response');
    }

    return (data['results'] as List)
        .map((movie) => Movie.fromJson(movie))
        .toList();
  }

  Future<List<Movie>> getPopularMovies() {
    return getMovies('/movie/popular');
  }

  Future<List<Movie>> getNowPlayingMovies() {
    return getMovies('/movie/now_playing');
  }

  Future<List<Movie>> getTopRatedMovies() {
    return getMovies('/movie/top_rated');
  }

  Future<List<Movie>> getUpcomingMovies() {
    return getMovies('/movie/upcoming');
  }

  Future<List<Movie>> searchMovies(String query) async {
    final encodedQuery = Uri.encodeQueryComponent(query);

    final uri = Uri.parse(
      '$baseUrl/search/movie?api_key=$apiKey'
      '&language=en-US&query=$encodedQuery',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Search failed');
    }

    final data = jsonDecode(response.body);

    if (data is! Map || data['results'] is! List) {
      throw Exception('Invalid search response');
    }

    return (data['results'] as List)
        .map((movie) => Movie.fromJson(movie))
        .toList();
  }
}