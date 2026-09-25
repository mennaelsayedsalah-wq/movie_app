import '../../models/movie.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> popular;
  final List<Movie> nowPlaying;
  final List<Movie> topRated;
  final List<Movie> upcoming;

  MovieLoaded({
    required this.popular,
    required this.nowPlaying,
    required this.topRated,
    required this.upcoming,
  });
}

class MovieSearchLoaded extends MovieState {
  final List<Movie> movies;

  MovieSearchLoaded(this.movies);
}

class MovieEmpty extends MovieState {}

class MovieError extends MovieState {
  final String message;

  MovieError(this.message);
}