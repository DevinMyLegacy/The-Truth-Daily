import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/verse_provider.dart';
import 'screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv

void main() async {
  // CRITICAL: Ensure Flutter is initialized before accessing plugins like dotenv
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VerseProvider()..loadDailyVerse(),
      child: MaterialApp(
        title: 'Verse of the Day',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
