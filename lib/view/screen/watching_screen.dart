import 'package:flutter/material.dart';

import 'movie_list_screen.dart';

class WatchingScreen extends StatelessWidget {
  const WatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MovieListScreen(
      title: 'Watching',
      listName: 'watching',
    );
  }
}