import 'dart:async';
import 'dart:convert';

import 'package:ai_chat_bot/core/network/api_client.dart';
import 'package:ai_chat_bot/feature/chat/domain/entities/chat_stream_event.dart';
import 'package:dio/dio.dart';

class TripGenieApi {
  TripGenieApi(this._client);

  final ApiClient _client;

  // this will keep listening to the stream until it's done or cancelled
  Stream<ChatStreamEvent> streamChat({
    required String question,
    String? conversationId,
    int limit = 5,
    CancelToken? cancelToken,
  }) async* {
    final response = await _client.post<ResponseBody>(
      '/api/genie/chat/stream',
      data: {
        if (conversationId != null && conversationId.isNotEmpty)
          'conversationId': conversationId,
        'question': question,
        'limit': limit,
      },
      options: Options(
        responseType: ResponseType.stream,
        headers: const {
          'Accept': 'text/event-stream',
          'Content-Type': 'application/json',
          'Cache-Control': 'no-cache',
        },
      ),
      cancelToken: cancelToken,
    );

    final responseBody = response.data;
    if (responseBody == null) {
      throw StateError('Expected a stream response body.');
    }

    final stream = responseBody.stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    final dataLines = <String>[];
    String? eventName;

    await for (final line in stream) {
      if (line.isEmpty) {
        final event = _buildEvent(eventName, dataLines);
        if (event != null) {
          yield event;
        }

        eventName = null;
        dataLines.clear();
        continue;
      }

      if (line.startsWith(':')) {
        continue;
      }

      if (line.startsWith('event:')) {
        eventName = line.substring(6).trim();
      } else if (line.startsWith('data:')) {
        dataLines.add(line.substring(5).trimLeft());
      }
    }

    final event = _buildEvent(eventName, dataLines);
    if (event != null) {
      yield event;
    }
  }

  ChatStreamEvent? _buildEvent(String? eventName, List<String> dataLines) {
    if (eventName == null || dataLines.isEmpty) {
      return null;
    }

    return ChatStreamEvent(
      event: eventName,
      data: jsonDecode(dataLines.join('\n')),
    );
  }
}
