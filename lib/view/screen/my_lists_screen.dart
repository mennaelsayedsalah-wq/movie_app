import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'favorites_screen.dart';
import 'watched_screen.dart';
import 'watching_screen.dart';
import 'want_to_watch_screen.dart';

class MyListsScreen extends StatelessWidget {
  const MyListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lists = [
      {
        'title': 'Favorites',
        'subtitle': 'Movies you love',
        'icon': Icons.favorite,
        'color': Colors.redAccent,
        'page': const FavoritesScreen(),
      },
      {
        'title': 'Watched',
        'subtitle': 'Movies you already watched',
        'icon': Icons.check_circle,
        'color': Colors.green,
        'page': const WatchedScreen(),
      },
      {
        'title': 'Watching',
        'subtitle': 'Movies you are watching',
        'icon': Icons.play_circle_fill,
        'color': Colors.blueAccent,
        'page': const WatchingScreen(),
      },
      {
        'title': 'Want to Watch',
        'subtitle': 'Movies for later',
        'icon': Icons.bookmark,
        'color': Colors.orange,
        'page': const WantToWatchScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Lists',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: lists.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final item = lists[index];

          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => item['page'] as Widget,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.Surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    height: 58,
                    width: 58,
                    decoration: BoxDecoration(
                      color: (item['color'] as Color)
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: item['color'] as Color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item['subtitle'] as String,
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.grey,
                    size: 18,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}