import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Movie> _favorites = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Movie> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites(); // Load favorites from Firestore
  }

  void toggleFavorite(Movie movie) async {
    if (isFavorite(movie)) {
      _favorites.removeWhere((fav) => fav.id == movie.id);
      await _firestore.collection('favorites').doc(movie.id.toString()).delete();
    } else {
      _favorites.add(movie);
      await _firestore.collection('favorites').doc(movie.id.toString()).set(movie.toJson());
    }
    await _saveFavoritesLocally(); // Save to shared preferences
    notifyListeners();
  }

  bool isFavorite(Movie movie) {
    return _favorites.any((fav) => fav.id == movie.id);
  }

  Future<void> _loadFavorites() async {
    try {
      // Load from Firestore
      final snapshot = await _firestore.collection('favorites').get();
      _favorites.clear();
      _favorites.addAll(snapshot.docs.map((doc) => Movie.fromJson(doc.data())));
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading favorites from Firestore: $e");
    }

    // Load from shared preferences (fallback for offline support)
    await _loadFavoritesLocally();
  }

  Future<void> _saveFavoritesLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Save favorite movie IDs locally
      final favoriteIds = _favorites.map((movie) => movie.id).toList();
      prefs.setStringList('favorites', favoriteIds.map((e) => e.toString()).toList());
    } catch (e) {
      debugPrint("Error saving favorites locally: $e");
    }
  }

  Future<void> _loadFavoritesLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorites') ?? [];

      // Sync local favorites with Firestore data
      for (final id in favoriteIds) {
        if (!_favorites.any((movie) => movie.id == int.parse(id))) {
          debugPrint('Movie with ID $id is in local favorites but not loaded from Firestore');
        }
      }
    } catch (e) {
      debugPrint("Error loading favorites locally: $e");
    }
  }
}
