import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  final SpeechToText _speechToText = SpeechToText();

  bool _isInitialized = false;

  Future<bool> init() async {
    _isInitialized = await _speechToText.initialize();
    return _isInitialized;
  }

  Future<bool> startListening({
    required void Function(String text) onTextChanged,
    required void Function(double level) onSoundLevelChanged,
  }) async {
    if (!_isInitialized) {
      final available = await init();
      if (!available) return false;
    }

    await _speechToText.listen(
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        partialResults: true,
        pauseFor: const Duration(seconds: 3),
      ),

      onResult: (result) {
        onTextChanged(result.recognizedWords);
      },
      onSoundLevelChange: (level) {
        onSoundLevelChanged(level);
      },
    );

    return _speechToText.isListening;
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  Future<void> cancelListening() async {
    await _speechToText.cancel();
  }
}
