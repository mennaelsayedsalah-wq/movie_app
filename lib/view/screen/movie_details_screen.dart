import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../models/movie.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';

import '../../bloc/lists/lists_bloc.dart';
import '../../bloc/lists/lists_event.dart';
import '../../bloc/lists/lists_state.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailsScreen> createState() =>
      _MovieDetailsScreenState();
}

class _MovieDetailsScreenState
    extends State<MovieDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState =
          context.read<AuthBloc>().state;

      if (authState is Authenticated) {
        context.read<ListsBloc>().add(
              LoadMovieLists(
                userId: authState.user.id,
                movieId: widget.movie.id,
              ),
            );
      }
    });
  }

  void toggleList({
    required String listName,
    required bool value,
  }) {
    final authState =
        context.read<AuthBloc>().state;

    if (authState is! Authenticated) {
      return;
    }

    context.read<ListsBloc>().add(
          ToggleMovieList(
            userId: authState.user.id,
            movie: widget.movie,
            listName: listName,
            value: value,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      body: BlocBuilder<ListsBloc, ListsState>(
        builder: (context, listState) {
          Map<String, bool> lists = {
            'favorite': false,
            'watched': false,
            'watching': false,
            'wantToWatch': false,
          };

          if (listState
              is MovieListsLoaded) {
            lists = listState.lists;
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 430,
                pinned: true,
                backgroundColor:
                    AppColors.background,

                leading: IconButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                ),

                flexibleSpace:
                    FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        movie.backdropPath.isEmpty
                            ? 'https://via.placeholder.com/800x450'
                            : 'https://image.tmdb.org/t/p/w780${movie.backdropPath}',
                        fit: BoxFit.cover,
                      ),

                      Container(
                        decoration:
                            BoxDecoration(
                          gradient:
                              LinearGradient(
                            begin:
                                Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black
                                  .withOpacity(0.15),
                              AppColors.background,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w300${movie.posterPath}',
                              height: 190,
                              width: 125,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  movie.title,
                                  style:
                                      const TextStyle(
                                    fontSize: 24,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 12,
                                ),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color:
                                          Colors.amber,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                        width: 5),
                                    Text(
                                      movie.rating
                                          .toStringAsFixed(
                                              1),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                    height: 10),

                                Text(
                                  movie.releaseDate
                                          .isEmpty
                                      ? 'Release date unavailable'
                                      : movie
                                          .releaseDate,
                                  style:
                                      const TextStyle(
                                    color:
                                        AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'My Lists',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      _listButton(
                        icon: Icons.favorite,
                        title: 'Favorite',
                        active:
                            lists['favorite']!,
                        onTap: () {
                          toggleList(
                            listName:
                                'favorite',
                            value:
                                !lists['favorite']!,
                          );
                        },
                      ),

                      _listButton(
                        icon: Icons.check_circle,
                        title: 'Watched',
                        active:
                            lists['watched']!,
                        onTap: () {
                          toggleList(
                            listName: 'watched',
                            value:
                                !lists['watched']!,
                          );
                        },
                      ),

                      _listButton(
                        icon: Icons.play_circle,
                        title: 'Watching',
                        active:
                            lists['watching']!,
                        onTap: () {
                          toggleList(
                            listName: 'watching',
                            value:
                                !lists['watching']!,
                          );
                        },
                      ),

                      _listButton(
                        icon: Icons.bookmark,
                        title: 'Want to Watch',
                        active:
                            lists['wantToWatch']!,
                        onTap: () {
                          toggleList(
                            listName:
                                'wantToWatch',
                            value:
                                !lists['wantToWatch']!,
                          );
                        },
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        movie.overview.isEmpty
                            ? 'No overview available.'
                            : movie.overview,
                        style:
                            const TextStyle(
                          color: AppColors.grey,
                          height: 1.6,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _listButton({
    required IconData icon,
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: active
            ? AppColors.Primary
                .withOpacity(0.18)
            : AppColors.Surface,
        borderRadius:
            BorderRadius.circular(14),
      ),

      child: ListTile(
        onTap: onTap,

        leading: Icon(
          icon,
          color: active
              ? AppColors.accent
              : AppColors.grey,
        ),

        title: Text(title),

        trailing: Icon(
          active
              ? Icons.check_circle
              : Icons.add_circle_outline,
          color: active
              ? AppColors.accent
              : AppColors.grey,
        ),
      ),
    );
  }
}