import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';
import '../widgets/movie_card.dart'; // Import MovieCard widget

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController searchController = TextEditingController();
  List<Movie> searchResults = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final results = await apiService.searchMovies(query);
      setState(() {
        searchResults = results.map((e) => Movie.fromJson(e)).toList();
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching search results. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Enter movie title',
                hintStyle: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme.primaryColor,
                    width: 1.0,
                  ),
                ),
                prefixIcon: Icon(Icons.search, color: theme.primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: theme.iconTheme.color),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      searchResults.clear();
                    });
                  },
                ),
              ),
              onSubmitted: searchMovies,
              style: theme.textTheme.bodyMedium,
            ),
          ),

          // Search Results or Loading/Error
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : errorMessage.isNotEmpty
                ? Center(
              child: Text(
                errorMessage,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            )
                : searchResults.isEmpty
                ? Center(
              child: Text(
                'No results found. Try searching for something else.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                itemCount: searchResults.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two cards per row
                  crossAxisSpacing: 16, // Space between columns
                  mainAxisSpacing: 16, // Space between rows
                  childAspectRatio: 0.60, // Adjust aspect ratio for cards
                ),
                itemBuilder: (context, index) {
                  final movie = searchResults[index];
                  return MovieCard(movie: movie); // Use MovieCard widget
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
