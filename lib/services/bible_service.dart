import 'dart:math';
import 'package:bible/bible.dart' as Bible;
import '../models/verse_model.dart';

class BibleService {
  final List<Map<String, String>> _curatedVerses = [
    {
      'command': 'John 14:15', // "If you love me, keep my commands."
      'promise': 'John 14:21', // Love/reward
      'rights': 'As believers, obedience manifests the Spirit\'s fruit: love, joy, peace (Gal 5:22).',
      'prayer': 'Lord, help me obey Your commands to experience Your promises today.'
    },
    {
      'command': 'Deuteronomy 28:1',
      'promise': 'Deuteronomy 28:2',
      'rights': 'Blessings overflow in city/field as we walk in obedience.',
      'prayer': 'Father, grant strength for obedience and reveal Your blessings.'
    },
    {
      'command': 'Luke 11:28',
      'promise': 'John 14:23',
      'rights': 'Hearing and obeying brings blessed assurance and divine presence.',
      'prayer': 'Spirit, empower my obedience for Your manifest glory.'
    },
    {
      'command': '1 John 5:3',
      'promise': 'Psalm 1:3',
      'rights': 'His commands aren\'t burdensome, they lead to fruitfulness by the water.',
      'prayer': 'Dear God, let Your will be my delight and my path to success.'
    },
    {
      'command': '1 Peter 1:14',
      'promise': 'Ephesians 2:10',
      'rights': 'We are transformed from worldly desires into obedient children, created for good works.',
      'prayer': 'Holy Spirit, conform my will to Christ’s and guide my actions.'
    },
  ];

  Future<VerseModel> getStructuredDailyVerse() async {
    final today = DateTime.now();
    final seed = today.year * 10000 + today.month * 100 + today.day;
    final random = Random(seed);
    final index = random.nextInt(_curatedVerses.length);
    final selected = _curatedVerses[index];

    final commandTextResult = await Bible.queryPassage(selected['command']!, providerName: 'getbible');
    final promiseTextResult = await Bible.queryPassage(selected['promise']!, providerName: 'getbible');
    
    final commandText = commandTextResult.passage.isEmpty ? 'Verse text unavailable.' : commandTextResult.passage;
    final promiseText = promiseTextResult.passage.isEmpty ? 'Verse text unavailable.' : promiseTextResult.passage;

    return VerseModel(
      command: '${selected['command']}: $commandText',
      promise: '${selected['promise']}: $promiseText',
      rights: selected['rights']!,
      prayer: selected['prayer']!,
    );
  }
}
