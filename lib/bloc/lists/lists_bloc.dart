import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/movie_list_controller.dart';
import 'lists_event.dart';
import 'lists_state.dart';

class ListsBloc extends Bloc<ListsEvent, ListsState> {
  final ListController controller;

  ListsBloc({
    ListController? controller,
  })  : controller = controller ?? ListController(),
        super(ListsInitial()) {
    on<LoadListMovies>(_loadListMovies);
    on<ToggleMovieList>(_toggleMovieList);
    on<LoadMovieLists>(_loadMovieLists);
  }

  Future<void> _loadListMovies(
    LoadListMovies event,
    Emitter<ListsState> emit,
  ) async {
    emit(ListsLoading());

    try {
      final movies = await controller.getMoviesByList(
        userId: event.userId,
        listName: event.listName,
      );

      if (movies.isEmpty) {
        emit(ListsEmpty(event.listName));
      } else {
        emit(
          ListsLoaded(
            movies: movies,
            listName: event.listName,
          ),
        );
      }
    } catch (e) {
      emit(
        ListsError(
          'Could not load your movies. Please try again.',
        ),
      );
    }
  }

  Future<void> _toggleMovieList(
    ToggleMovieList event,
    Emitter<ListsState> emit,
  ) async {
    try {
      await controller.updateList(
        userId: event.userId,
        movie: event.movie,
        listName: event.listName,
        value: event.value,
      );

      final lists = await controller.getMovieLists(
        userId: event.userId,
        movieId: event.movie.id,
      );

      emit(MovieListsLoaded(lists));
    } catch (e) {
      emit(
        ListsError(
          'Could not update the movie list.',
        ),
      );
    }
  }

  Future<void> _loadMovieLists(
    LoadMovieLists event,
    Emitter<ListsState> emit,
  ) async {
    emit(ListsLoading());

    try {
      final lists = await controller.getMovieLists(
        userId: event.userId,
        movieId: event.movieId,
      );

      emit(MovieListsLoaded(lists));
    } catch (e) {
      emit(
        ListsError(
          'Could not load movie lists.',
        ),
      );
    }
  }
}