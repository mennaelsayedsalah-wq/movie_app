import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../bloc/movie/bloc.dart';
import '../../bloc/movie/event.dart';
import '../../bloc/movie/state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends State<SearchScreen> {
  final searchController =
      TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void search() {
    final query =
        searchController.text.trim();

    if (query.isEmpty) return;

    context.read<MovieBloc>().add(
          SearchMovies(query),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Movies',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              textInputAction:
                  TextInputAction.search,
              onSubmitted: (_) => search(),
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                prefixIcon:
                    const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: search,
                  icon: const Icon(
                    Icons.arrow_forward,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<
                  MovieBloc,
                  MovieState>(
                builder: (context, state) {
                  if (state is MovieLoading) {
                    return const LoadingWidget();
                  }

                  if (state is MovieError) {
                    return Center(
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.grey,
                        ),
                      ),
                    );
                  }

                  if (state is MovieEmpty) {
                    return const Center(
                      child: Text(
                        'No movies found.',
                        style: TextStyle(
                          color: AppColors.grey,
                        ),
                      ),
                    );
                  }

                  if (state
                      is MovieSearchLoaded) {
                    return GridView.builder(
                      itemCount:
                          state.movies.length,

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 18,
                        childAspectRatio: 0.58,
                      ),

                      itemBuilder:
                          (context, index) {
                        final movie =
                            state.movies[index];

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
                    );
                  }

                  return const Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 70,
                          color: AppColors.grey,
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Find your next movie',
                          style: TextStyle(
                            color:
                                AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}