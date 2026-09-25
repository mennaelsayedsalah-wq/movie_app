import '../../models/movie.dart';

abstract class ListsState {}

class ListsInitial extends ListsState {}

class ListsLoading extends ListsState {}

class ListsLoaded extends ListsState {
  final List<Movie> movies;
  final String listName;

  ListsLoaded({
    required this.movies,
    required this.listName,
  });
}

class MovieListsLoaded extends ListsState {
  final Map<String, bool> lists;

  MovieListsLoaded(this.lists);
}

class ListsEmpty extends ListsState {
  final String listName;

  ListsEmpty(this.listName);
}

class ListsError extends ListsState {
  final String message;

  ListsError(this.message);
}