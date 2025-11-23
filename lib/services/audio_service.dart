import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AudioService {
  static const String baseUrl = 'https://api.scripture.api.bible/v1';
  final String apiKey = dotenv.env['API_BIBLE_KEY'] ?? '';

  // Hardcode the Audio Bible ID (Example KJV Audio ID)
  String getAudioBibleId() {
    return 'N2KVN2DA'; 
  }

  Future<String?> getAudioUrl(String reference, String audioBibleId) async {
    // Reference format example: 'John 14:15: If you love me...'
    final refPart = reference.split(':')[0].trim(); 
    
    final parts = refPart.split(' ');
    
    if (parts.length < 2) {
      throw Exception('Invalid reference format for audio parsing: $reference');
    }
    
    final book = parts[0].trim();
    final chapterVerse = parts.sublist(1).join(' ').trim();
    final chapter = chapterVerse.split(':')[0]; 
    
    final bookCode = _getBookCode(book); 
    
    final chapterId = '$audioBibleId.$bookCode.$chapter'; 

    final url = Uri.parse('$baseUrl/audio-bibles/$audioBibleId/chapters/$chapterId');
    final response = await http.get(url, headers: {'api-key': apiKey});
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      final audioUrl = data['audioUri'] as String?; 
      
      if (audioUrl != null) {
         return audioUrl;
      }
      
      final audioList = data['audio'] as List<dynamic>?;
      if (audioList != null && audioList.isNotEmpty) {
        return audioList[0]['url'] as String?; 
      }
      throw Exception('No audio URL found in response data.');
      
    }
    throw Exception('Audio fetch failed with status ${response.statusCode}: ${response.reasonPhrase}');
  }

  String _getBookCode(String book) {
    const map = {
      'John': 'JHN',
      'Deuteronomy': 'DEU',
      'Luke': 'LUK',
      '1 John': '1JN',
      '1 Peter': '1PE',
    };
    return map[book] ?? (throw Exception('Unsupported book for audio: $book'));
  }
}
