import '../models/movie.dart';
import '../services/database_service.dart';

class ListController {
  final DatabaseService databaseService;

  ListController({
    DatabaseService? databaseService,
  }) : databaseService = databaseService ?? DatabaseService();

  Future<void> updateList({
    required String userId,
    required Movie movie,
    required String listName,
    required bool value,
  }) {
    return databaseService.updateMovieList(
      userId: userId,
      movie: movie,
      listName: listName,
      value: value,
    );
  }

  Future<List<Movie>> getMoviesByList({
    required String userId,
    required String listName,
  }) {
    return databaseService.getMoviesByList(
      userId: userId,
      listName: listName,
    );
  }

  Future<Map<String, bool>> getMovieLists({
    required String userId,
    required int movieId,
  }) {
    return databaseService.getMovieLists(
      userId: userId,
      movieId: movieId,
    );
  }

  Future<void> deleteMovie({
    required String userId,
    required int movieId,
  }) {
    return databaseService.deleteMovie(
      userId: userId,
      movieId: movieId,
    );
  }
}