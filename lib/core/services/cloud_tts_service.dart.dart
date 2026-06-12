import 'package:ai_chat_bot/core/network/api_client.dart';
import 'package:ai_chat_bot/core/utils/app_logger.dart';
import 'package:just_audio/just_audio.dart';

class CloudTtsService {
  CloudTtsService({required this._apiClient});

  final ApiClient _apiClient;
  final AudioPlayer _player = AudioPlayer();

  Future<void> speak(String text) async {
    final cleanText = _cleanText(text);
    if (cleanText.isEmpty) return;

    try {
      await _player.stop();

      final response = await _apiClient.post(
        '/api/genie/tts',
        data: {'text': cleanText},
      );

      final audioUrl = response.data['audioUrl'] as String?;

      if (audioUrl == null || audioUrl.isEmpty) {
        throw Exception('TTS audioUrl is empty');
      }

      await _player.setUrl(audioUrl);
      await _player.play();
    } catch (e) {
      AppLogger.error('Cloud TTS error: $e');
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }

  String _cleanText(String text) {
    var cleaned = text
        .replaceAll(RegExp(r'```[\s\S]*?```'), ' ')
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAllMapped(
          RegExp(r'!\[([^\]]*)\]\([^)]+\)'),
          (match) => match.group(1) ?? '',
        )
        .replaceAllMapped(
          RegExp(r'\[([^\]]+)\]\([^)]+\)'),
          (match) => match.group(1) ?? '',
        )
        .replaceAll(
          RegExp(r'^\s*\|?\s*:?-{3,}:?\s*(\|\s*:?-{3,}:?\s*)+\|?\s*$',
              multiLine: true),
          ' ',
        )
        .replaceAll(RegExp(r'^\s{0,3}#{1,6}\s+', multiLine: true), '')
        .replaceAll(RegExp(r'^\s*(?:[-*+]\s+|\d+\.\s+)', multiLine: true), '')
        .replaceAll('|', ' ')
        .replaceAll(RegExp(r'[\r\n]+'), '. ')
        .replaceAll(RegExp(r'[*_`>#]'), '');

    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    return cleaned;
  }
}
