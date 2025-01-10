import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_model.dart';

class WatchlistProvider with ChangeNotifier {
  final List<Movie> _watchlist = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Movie> get watchlist => _watchlist;

  WatchlistProvider() {
    _loadWatchlist();
  }

  void toggleWatchlist(Movie movie) async {
    if (isInWatchlist(movie)) {
      _watchlist.removeWhere((item) => item.id == movie.id);
      await _firestore
          .collection('watchlist')
          .doc(movie.id.toString())
          .delete();
    } else {
      _watchlist.add(movie);
      await _firestore
          .collection('watchlist')
          .doc(movie.id.toString())
          .set(movie.toJson());
    }
    notifyListeners();
  }

  bool isInWatchlist(Movie movie) {
    return _watchlist.any((item) => item.id == movie.id);
  }

  Future<void> _loadWatchlist() async {
    final snapshot = await _firestore.collection('watchlist').get();
    _watchlist.clear();
    _watchlist.addAll(
      snapshot.docs.map((doc) => Movie.fromJson(doc.data())),
    );
    notifyListeners();
  }
}
