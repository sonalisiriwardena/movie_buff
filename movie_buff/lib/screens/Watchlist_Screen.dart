import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/watchlist_provider.dart';
import '../widgets/movie_card.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final watchlistProvider = context.watch<WatchlistProvider>();
    final watchlist = watchlistProvider.watchlist;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist'),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: watchlist.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 80,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No movies in your watchlist!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add movies to your watchlist to see them here.',
              style: TextStyle(
                fontSize: 14,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          itemCount: watchlist.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two cards per row
            crossAxisSpacing: 16, // Space between columns
            mainAxisSpacing: 16, // Space between rows
            childAspectRatio: 0.60, // Adjusted aspect ratio for better fit
          ),
          itemBuilder: (context, index) {
            final movie = watchlist[index];
            return MovieCard(
              movie: movie,
              onAction: () {
                watchlistProvider.toggleWatchlist(movie);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${movie.title} removed from watchlist.',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
