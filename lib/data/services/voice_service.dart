import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;

class VoiceService extends GetxService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _tts = FlutterTts();
  
  final RxBool isPlaying = false.obs;

  VoiceService() {
    _init();
  }

  void _init() {
    _tts.setLanguage("en-US");
    _tts.setSpeechRate(0.5);
    
    _audioPlayer.onPlayerStateChanged.listen((state) {
      dev.log('🔊 AudioPlayer State: $state');
      isPlaying.value = (state == PlayerState.playing);
    });

    _tts.setStartHandler(() {
      dev.log('🔊 TTS Started speaking');
      isPlaying.value = true;
    });

    _tts.setCompletionHandler(() {
      dev.log('🔊 TTS Finished speaking');
      isPlaying.value = false;
    });

    _tts.setErrorHandler((msg) {
      dev.log('❌ TTS Error: $msg');
      isPlaying.value = false;
    });
  }

  Future<void> speak(String text, {String? url}) async {
    dev.log('🔊 VoiceService: Request to speak "$text"');
    
    // Stop any current playback
    await stop();

    if (url != null && url.isNotEmpty) {
      dev.log('🔊 VoiceService: Attempting URL playback: $url');
      try {
        await _audioPlayer.play(UrlSource(url));
        return;
      } catch (e) {
        dev.log('❌ VoiceService: URL Playback failed, falling back to TTS. Error: $e');
      }
    }
    
    dev.log('🔊 VoiceService: Starting TTS for text: $text');
    try {
      await _tts.speak(text);
    } catch (e) {
      dev.log('❌ VoiceService: TTS failed. Error: $e');
      isPlaying.value = false;
    }
  }

  Future<void> stop() async {
    dev.log('🔊 VoiceService: Stopping all playback');
    await _audioPlayer.stop();
    await _tts.stop();
    isPlaying.value = false;
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    _tts.stop();
    super.onClose();
  }
}
