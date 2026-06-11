import 'package:ai_chat_bot/feature/chat/data/data_sources/trip_genie_api.dart';
import 'package:ai_chat_bot/feature/chat/domain/entities/chat_stream_event.dart';
import 'package:ai_chat_bot/feature/chat/domain/repositories/chat_repository.dart';
import 'package:dio/dio.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._api);

  final TripGenieApi _api;

  @override
  Stream<ChatStreamEvent> streamChat({
    required String question,
    String? conversationId,
    int limit = 5,
    CancelToken? cancelToken,
  }) {
    return _api.streamChat(
      question: question,
      conversationId: conversationId,
      limit: limit,
      cancelToken: cancelToken,
    );
  }
}
