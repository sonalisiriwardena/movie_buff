import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/watchlist_provider.dart'; // Import WatchlistProvider
import 'providers/theme_provider.dart'; // Import ThemeProvider
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()), // Add WatchlistProvider
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add ThemeProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access ThemeProvider
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      title: 'Movie Buff',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      themeMode: themeProvider.themeMode, // Use themeMode from ThemeProvider
      home: const HomeScreen(),
    );
  }
}
