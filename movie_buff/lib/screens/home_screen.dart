import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';
import '../providers/watchlist_provider.dart';
import '../providers/theme_provider.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';
import 'watchlist_screen.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<Movie> movies = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final results = await apiService.fetchPopularMovies();
      setState(() {
        movies = results.map((e) => Movie.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch movies. Please try again later.';
        isLoading = false;
      });
      print('Error fetching movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 8),
            const Text(
              'Popular Movies',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? Colors.black
            : Colors.lightBlue,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.list_alt, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WatchlistScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          Switch(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
            activeColor: Colors.yellow,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          itemCount: movies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two cards per row
            crossAxisSpacing: 16, // Space between columns
            mainAxisSpacing: 16, // Space between rows
            childAspectRatio: 0.6, // Adjusted aspect ratio for a better fit
          ),
          itemBuilder: (context, index) {
            final movie = movies[index];
            return MovieCard(
              movie: movie,
            );
          },
        ),
      ),
    );
  }
}
