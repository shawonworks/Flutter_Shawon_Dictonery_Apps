import 'package:flutter_tts/flutter_tts.dart';

class TtsHelper {
  static final FlutterTts _tts = FlutterTts();
  static bool _initialized = false;

  static Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _initialized = true;
  }

  static Future<void> speak(String text) async {
    try {
      await _ensureInitialized();
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      // Failed to speak
    }
  }

  static Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e) {
      // Failed to stop
    }
  }
}
