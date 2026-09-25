abstract class MovieEvent {}

class LoadMovies extends MovieEvent {}

class SearchMovies extends MovieEvent {
  final String query;

  SearchMovies(this.query);
}