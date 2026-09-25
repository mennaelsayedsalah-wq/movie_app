import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        'https://image.tmdb.org/t/p/w500${movie.posterPath}';

    return GestureDetector(
      onTap: onTap,

      child: SizedBox(
        width: 145,

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(14),

              child: SizedBox(
                height: 210,
                width: 145,

                child: movie.posterPath.isEmpty
                    ? Container(
                        color: AppColors.Surface,
                        child: const Center(
                          child: Icon(
                            Icons.movie,
                            size: 45,
                            color: AppColors.grey,
                          ),
                        ),
                      )
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,

                        errorBuilder:
                            (context, error, stackTrace) {
                          return Container(
                            color: AppColors.Surface,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: AppColors.grey,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 16,
                ),

                const SizedBox(width: 4),

                Text(
                  movie.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}