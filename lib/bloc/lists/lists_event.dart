import '../../models/movie.dart';

abstract class ListsEvent {}

class LoadListMovies extends ListsEvent {
  final String userId;
  final String listName;

  LoadListMovies({
    required this.userId,
    required this.listName,
  });
}

class ToggleMovieList extends ListsEvent {
  final String userId;
  final Movie movie;
  final String listName;
  final bool value;

  ToggleMovieList({
    required this.userId,
    required this.movie,
    required this.listName,
    required this.value,
  });
}

class LoadMovieLists extends ListsEvent {
  final String userId;
  final int movieId;

  LoadMovieLists({
    required this.userId,
    required this.movieId,
  });
}