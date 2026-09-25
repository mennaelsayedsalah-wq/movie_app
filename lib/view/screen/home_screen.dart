import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../bloc/movie/bloc.dart';
import '../../bloc/movie/event.dart';
import '../../bloc/movie/state.dart';
import '../widgets/movie_card.dart';
import '../widgets/loading_widget.dart';

import 'movie_details_screen.dart';
import 'search_screen.dart';
import 'my_lists_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeContent(),
    SearchScreen(),
    MyListsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        backgroundColor: AppColors.Surface,
        indicatorColor:
            AppColors.Primary.withOpacity(0.25),
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'My Lists',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieBloc>().add(LoadMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const LoadingWidget();
            }

            if (state is MovieError) {
              return _ErrorView(
                message: state.message,
              );
            }

            if (state is MovieEmpty) {
              return const Center(
                child: Text(
                  'No movies available.',
                  style: TextStyle(
                    color: AppColors.grey,
                  ),
                ),
              );
            }

            if (state is MovieLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<MovieBloc>()
                      .add(LoadMovies());
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildHeader(),
                    ),

                    SliverToBoxAdapter(
                      child: _buildHero(state),
                    ),

                    SliverToBoxAdapter(
                      child: MovieSection(
                        title: 'Popular',
                        movies: state.popular,
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: MovieSection(
                        title: 'Now Playing',
                        movies: state.nowPlaying,
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: MovieSection(
                        title: 'Top Rated',
                        movies: state.topRated,
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: MovieSection(
                        title: 'Upcoming',
                        movies: state.upcoming,
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: 20),
                    ),
                  ],
                ),
              );
            }

            return const LoadingWidget();
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        10,
      ),
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: AppColors.Primary,
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.movie_filter,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'CineNova',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Discover your next favorite movie',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(MovieLoaded state) {
    if (state.popular.isEmpty) {
      return const SizedBox();
    }

    final movie = state.popular.first;

    return Container(
      height: 250,
      margin: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  MovieDetailsScreen(movie: movie),
            ),
          );
        },
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://image.tmdb.org/t/p/w780${movie.backdropPath}',
                fit: BoxFit.cover,
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 20,
                right: 20,
                bottom: 18,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FEATURED',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          movie.rating
                              .toStringAsFixed(1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieSection extends StatelessWidget {
  final String title;
  final List movies;

  const MovieSection({
    super.key,
    required this.title,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            14,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.grey,
              ),
            ],
          ),
        ),

        SizedBox(
          height: 285,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final movie = movies[index];

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
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 60,
              color: AppColors.accent,
            ),
            const SizedBox(height: 15),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context
                    .read<MovieBloc>()
                    .add(LoadMovies());
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}