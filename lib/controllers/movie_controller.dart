import '../models/movie.dart';
import '../services/tmdb_service.dart';

class MovieController {
  final TmdbService tmdbService;

  MovieController({
    TmdbService? tmdbService,
  }) : tmdbService = tmdbService ?? TmdbService();

  Future<List<Movie>> getPopularMovies() {
    return tmdbService.getPopularMovies();
  }

  Future<List<Movie>> getNowPlayingMovies() {
    return tmdbService.getNowPlayingMovies();
  }

  Future<List<Movie>> getTopRatedMovies() {
    return tmdbService.getTopRatedMovies();
  }

  Future<List<Movie>> getUpcomingMovies() {
    return tmdbService.getUpcomingMovies();
  }

  Future<List<Movie>> searchMovies(String query) {
    return tmdbService.searchMovies(query);
  }
}