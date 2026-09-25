import 'package:flutter/material.dart';

import 'movie_list_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MovieListScreen(
      title: 'Favorites',
      listName: 'favorite',
    );
  }
}