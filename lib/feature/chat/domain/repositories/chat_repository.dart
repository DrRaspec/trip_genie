import 'package:ai_chat_bot/feature/chat/domain/entities/chat_stream_event.dart';
import 'package:dio/dio.dart';

abstract class ChatRepository {
  Stream<ChatStreamEvent> streamChat({
    required String question,
    String? conversationId,
    int limit,
    CancelToken? cancelToken,
  });
}
