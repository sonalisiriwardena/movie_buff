import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/api_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? movieDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    try {
      final details = await apiService.fetchMovieDetails(widget.movie.id);
      setState(() {
        movieDetails = details;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching movie details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: theme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.movie.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.7),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              background: widget.movie.posterPath.isNotEmpty
                  ? Image.network(
                'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                fit: BoxFit.cover,
              )
                  : Container(
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.image,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie Title
                  Text(
                    widget.movie.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Movie Details Section
                  if (movieDetails != null) ...[
                    // Release Date
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          movieDetails!['release_date'] ?? 'N/A',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          '${movieDetails!['vote_average'] ?? 'N/A'} / 10',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Genres
                    const Text(
                      'Genres:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: (movieDetails!['genres'] as List<dynamic>)
                          .map(
                            (genre) => Chip(
                          label: Text(
                            genre['name'],
                            style: theme.textTheme.bodySmall,
                          ),
                          backgroundColor: theme.brightness ==
                              Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                        ),
                      )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Overview
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.overview.isNotEmpty
                        ? widget.movie.overview
                        : 'No overview available.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
