import 'package:flutter_tts/flutter_tts.dart';
import 'dart:developer' as dev;

class TtsHelper {
  static final FlutterTts _tts = FlutterTts();
  static bool _initialized = false;

  static Future<void> _ensureInitialized() async {
    if (_initialized) return;
    dev.log('🔊 TtsHelper: Initializing TTS engine...');
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _initialized = true;
  }

  static Future<void> speak(String text) async {
    dev.log('🔊 TtsHelper: Speaking -> $text');
    try {
      await _ensureInitialized();
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      dev.log('❌ TtsHelper: Error speaking -> $e');
    }
  }

  static Future<void> stop() async {
    dev.log('🔊 TtsHelper: Stopping playback');
    try {
      await _tts.stop();
    } catch (e) {
      dev.log('❌ TtsHelper: Error stopping -> $e');
    }
  }
}
