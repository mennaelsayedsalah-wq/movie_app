import 'package:flutter/material.dart';

import 'movie_list_screen.dart';

class WantToWatchScreen extends StatelessWidget {
  const WantToWatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MovieListScreen(
      title: 'Want to Watch',
      listName: 'wantToWatch',
    );
  }
}