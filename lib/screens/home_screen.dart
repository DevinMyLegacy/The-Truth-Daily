import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/verse_provider.dart';
import 'package:just_audio/just_audio.dart';
import '../services/audio_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String reference) async {
    if (_isPlaying) {
      await _stopAudio();
    }
    
    setState(() => _isPlaying = true);

    try {
      final audioService = AudioService();
      final audioBibleId = audioService.getAudioBibleId(); 
      final url = await audioService.getAudioUrl(reference, audioBibleId);
      
      if (url != null) {
        await _player.setUrl(url, tag: reference.split(':')[0].trim()); // Use reference as tag
        await _player.play();
        
        _player.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            setState(() => _isPlaying = false);
            _player.stop(); 
          }
        });
      } else {
        throw Exception('Audio URL is null.');
      }
    } catch (e) {
      setState(() => _isPlaying = false); 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Audio error: Cannot play verse audio. ${e.toString()}')));
    }
  }

  void _stopAudio() async {
    await _player.stop();
    setState(() => _isPlaying = false);
  }

  void _retryLoad(BuildContext context) {
    Provider.of<VerseProvider>(context, listen: false).loadDailyVerse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF191970),
      appBar: AppBar(
        title: Text('Verse of the Day', 
          style: GoogleFonts.pacifico(color: Color(0xFFF8F6F0))), 
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<VerseProvider>(
        builder: (context, provider, child) {
          final Color textColor = Color(0xFFF8F6F0);
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: textColor),
                  SizedBox(height: 10),
                  Text('Loading Today\'s Verse...', style: TextStyle(color: textColor)),
                ],
              ),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!, textAlign: TextAlign.center, style: TextStyle(color: Colors.redAccent, fontSize: 18)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _retryLoad(context),
                    child: Text('Retry'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Color(0xFF191970)),
                  ),
                ],
              ),
            );
          }
          final verse = provider.dailyVerse!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Today\'s Inspiration',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.pacifico(fontSize: 32, color: textColor)),
                SizedBox(height: 30),
                _buildSection('Command:', verse.command, textColor, verse.command),
                _buildSection('Promise:', verse.promise, textColor, verse.promise),
                _buildSection('Rights in Obedience:', verse.rights, textColor, null), 
                _buildSection('Prayer:', verse.prayer, textColor, null),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, String content, Color textColor, String? reference) {
    final rawReference = reference != null ? reference.split(':')[0].trim() : null;
    final isPlayingThis = _isPlaying && rawReference != null && _player.sequenceState?.currentSource?.tag == rawReference;

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0x33F8F6F0),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
              if (rawReference != null)
                IconButton(
                  icon: Icon(isPlayingThis ? Icons.stop : Icons.volume_up, color: textColor),
                  onPressed: () => isPlayingThis ? _stopAudio() : _playAudio(reference!),
                ),
            ],
          ),
          SizedBox(height: 8),
          Text(content, style: TextStyle(fontSize: 16, color: textColor)),
        ],
      ),
    );
  }
}
