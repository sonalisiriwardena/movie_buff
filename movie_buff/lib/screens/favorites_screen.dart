import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/movie_card.dart'; // Import MovieCard widget

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme
    final favoritesProvider = context.watch<FavoritesProvider>();
    final favorites = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: favorites.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
            const SizedBox(height: 14),
            Text(
              'No favorites yet!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Add movies to your favorites to see them here.',
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
          itemCount: favorites.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two cards per row
            crossAxisSpacing: 20, // Space between columns
            mainAxisSpacing: 20, // Space between rows
            childAspectRatio: 0.60, // Adjusted aspect ratio for better fit
          ),
          itemBuilder: (context, index) {
            final movie = favorites[index];
            return MovieCard(movie: movie); // Use MovieCard widget
          },
        ),
      ),
    );
  }
}
