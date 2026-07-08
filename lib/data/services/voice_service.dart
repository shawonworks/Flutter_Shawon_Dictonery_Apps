import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

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
      isPlaying.value = (state == PlayerState.playing);
    });

    _tts.setStartHandler(() {
      isPlaying.value = true;
    });

    _tts.setCompletionHandler(() {
      isPlaying.value = false;
    });

    _tts.setErrorHandler((msg) {
      isPlaying.value = false;
    });
  }

  Future<void> speak(String text, {String? url}) async {
    // Stop any current playback
    await stop();

    if (url != null && url.isNotEmpty) {
      try {
        await _audioPlayer.play(UrlSource(url));
        return;
      } catch (e) {
        // Fallback to TTS
      }
    }
    
    try {
      await _tts.speak(text);
    } catch (e) {
      isPlaying.value = false;
    }
  }

  Future<void> stop() async {
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
