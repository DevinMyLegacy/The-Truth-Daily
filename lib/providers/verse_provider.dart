import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/verse_model.dart';
import '../services/bible_service.dart';

class VerseProvider with ChangeNotifier {
  VerseModel? _dailyVerse;
  bool _isLoading = false;
  String? _error;

  VerseModel? get dailyVerse => _dailyVerse;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDailyVerse() async {
    if (_isLoading) return; 

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().split('T')[0]; 
      final cachedJson = prefs.getString('daily_verse_$today');

      if (cachedJson != null) {
        _dailyVerse = VerseModel.fromJson(Map<String, dynamic>.from(json.decode(cachedJson)));
      } else {
        _dailyVerse = await BibleService().getStructuredDailyVerse();
        await prefs.setString('daily_verse_$today', json.encode(_dailyVerse!.toJson()));
      }
    } catch (e) {
      _error = 'Failed to load verse: ${e.toString()}'; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
