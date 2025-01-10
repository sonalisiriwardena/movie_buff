import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/watchlist_provider.dart';
import '../screens/movie_details_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onAction;

  const MovieCard({
    Key? key,
    required this.movie,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movie: movie),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Dynamic height adjustment
          children: [
            // Movie Poster
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: movie.posterPath.isNotEmpty
                  ? Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 3),
            // Movie Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 3),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Favorite Button
                  Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, _) {
                      final isFavorite = favoritesProvider.isFavorite(movie);
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          favoritesProvider.toggleFavorite(movie);
                          final action = isFavorite ? 'removed from' : 'added to';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${movie.title} $action favorites.',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Watchlist Button
                  Consumer<WatchlistProvider>(
                    builder: (context, watchlistProvider, _) {
                      final isInWatchlist = watchlistProvider.isInWatchlist(movie);
                      return IconButton(
                        icon: Icon(
                          isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          watchlistProvider.toggleWatchlist(movie);
                          final action = isInWatchlist ? 'removed from' : 'added to';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${movie.title} $action watchlist.',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8), // Adjusted spacing for consistency
          ],
        ),
      ),
    );
  }
}
