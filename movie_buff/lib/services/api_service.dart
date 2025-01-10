import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = '47e62f827e7e2ed81dcefdf20d218a8e';
  final String baseUrl = 'https://api.themoviedb.org/3';

  /// Fetch popular movies
  Future<List<dynamic>> fetchPopularMovies() async {
    final url = Uri.parse('$baseUrl/movie/popular?api_key=$apiKey');
    final response = await _makeGetRequest(url);
    if (response.containsKey('results')) {
      return response['results'];
    } else {
      throw Exception('Unexpected API response structure');
    }
  }

  /// Fetch details of a specific movie
  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey');
    return await _makeGetRequest(url);
  }

  /// Search for movies by query
  Future<List<dynamic>> searchMovies(String query) async {
    final url = Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query');
    final response = await _makeGetRequest(url);
    if (response.containsKey('results')) {
      return response['results'];
    } else {
      throw Exception('Unexpected API response structure');
    }
  }

  /// Generalized GET request handler
  Future<Map<String, dynamic>> _makeGetRequest(Uri url) async {
    try {
      print('Fetching URL: $url'); // Debug: Log the URL being fetched
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Response: $jsonResponse'); // Debug: Log the API response
        return jsonResponse;
      } else {
        print('Error: ${response.body}'); // Debug: Log the error response
        throw Exception('Failed to fetch data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during GET request: $e'); // Debug: Log the exception
      throw Exception('Error during GET request: $e');
    }
  }
}
