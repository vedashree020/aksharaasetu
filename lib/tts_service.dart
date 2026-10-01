import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._();

  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _initialized = true;
  }

  Future<bool> isLanguageAvailable(String language) async {
    await initialize();

    final result = await _tts.isLanguageAvailable(language);

    if (result is bool) {
      return result;
    }

    if (result is int) {
      return result > 0;
    }

    return false;
  }

  Future<bool> speak({
    required String text,
    required String language,
  }) async {
    if (text.trim().isEmpty) {
      return false;
    }

    await initialize();

    final available = await isLanguageAvailable(language);

    if (!available) {
      return false;
    }

    await _tts.stop();

    await _tts.setLanguage(language);

    await _tts.speak(text.trim());

    return true;
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> dispose() async {
    await _tts.stop();
  }
}