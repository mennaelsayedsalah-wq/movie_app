import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/lists/lists_bloc.dart';
import '../../bloc/lists/lists_event.dart';
import '../../bloc/lists/lists_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

class MovieListScreen extends StatefulWidget {
  final String title;
  final String listName;

  const MovieListScreen({
    super.key,
    required this.title,
    required this.listName,
  });

  @override
  State<MovieListScreen> createState() =>
      _MovieListScreenState();
}

class _MovieListScreenState
    extends State<MovieListScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;

      if (authState is Authenticated) {
        context.read<ListsBloc>().add(
              LoadListMovies(
                userId: authState.user.id,
                listName: widget.listName,
              ),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! Authenticated) {
            return const Center(
              child: Text(
                'Please login first.',
                style: TextStyle(
                  color: AppColors.grey,
                ),
              ),
            );
          }

          return BlocBuilder<ListsBloc, ListsState>(
            builder: (context, state) {
              if (state is ListsLoading) {
                return const LoadingWidget();
              }

              if (state is ListsError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.accent,
                          size: 55,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<ListsBloc>()
                                .add(
                                  LoadListMovies(
                                    userId:
                                        authState.user.id,
                                    listName:
                                        widget.listName,
                                  ),
                                );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is ListsEmpty) {
                return _EmptyList(
                  title: widget.title,
                );
              }

              if (state is ListsLoaded) {
                return RefreshIndicator(
                  color: AppColors.Primary,
                  onRefresh: () async {
                    context.read<ListsBloc>().add(
                          LoadListMovies(
                            userId: authState.user.id,
                            listName: widget.listName,
                          ),
                        );
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.movies.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.60,
                    ),
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];

                      return MovieCard(
                        movie: movie,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MovieDetailsScreen(
                                movie: movie,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  final String title;

  const _EmptyList({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;

    if (title == 'Favorites') {
      icon = Icons.favorite_border;
    } else if (title == 'Watched') {
      icon = Icons.check_circle_outline;
    } else if (title == 'Watching') {
      icon = Icons.play_circle_outline;
    } else {
      icon = Icons.bookmark_border;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 75,
              color: AppColors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              'No movies in $title',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Open a movie and add it to this list.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}