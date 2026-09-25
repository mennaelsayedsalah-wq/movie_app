import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/movie_controller.dart';
import 'event.dart';
import 'state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieController controller;

  MovieBloc({
    MovieController? controller,
  })  : controller = controller ?? MovieController(),
        super(MovieInitial()) {
    on<LoadMovies>(_loadMovies);
    on<SearchMovies>(_searchMovies);
  }

  Future<void> _loadMovies(
    LoadMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());

    try {
      final results = await Future.wait([
        controller.getPopularMovies(),
        controller.getNowPlayingMovies(),
        controller.getTopRatedMovies(),
        controller.getUpcomingMovies(),
      ]);

      final popular = results[0];
      final nowPlaying = results[1];
      final topRated = results[2];
      final upcoming = results[3];

      if (popular.isEmpty &&
          nowPlaying.isEmpty &&
          topRated.isEmpty &&
          upcoming.isEmpty) {
        emit(MovieEmpty());
        return;
      }

      emit(
        MovieLoaded(
          popular: popular,
          nowPlaying: nowPlaying,
          topRated: topRated,
          upcoming: upcoming,
        ),
      );
    } catch (e) {
      emit(
        MovieError(
          'Something went wrong while loading movies.',
        ),
      );
    }
  }

  Future<void> _searchMovies(
    SearchMovies event,
    Emitter<MovieState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(MovieEmpty());
      return;
    }

    emit(MovieLoading());

    try {
      final movies = await controller.searchMovies(
        event.query.trim(),
      );

      if (movies.isEmpty) {
        emit(MovieEmpty());
      } else {
        emit(MovieSearchLoaded(movies));
      }
    } catch (e) {
      emit(
        MovieError(
          'Something went wrong while searching.',
        ),
      );
    }
  }
}