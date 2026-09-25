import 'package:flutter/material.dart';

import 'movie_list_screen.dart';

class WatchedScreen extends StatelessWidget {
  const WatchedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MovieListScreen(
      title: 'Watched',
      listName: 'watched',
    );
  }
}