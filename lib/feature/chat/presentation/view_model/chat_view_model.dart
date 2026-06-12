import 'package:ai_chat_bot/core/services/speech_to_text_service.dart';
import 'package:ai_chat_bot/feature/chat/data/models/chat_message.dart';
import 'package:ai_chat_bot/feature/chat/data/models/comparison_item.dart';
import 'package:ai_chat_bot/feature/chat/data/models/resource_summary.dart';
import 'package:ai_chat_bot/feature/chat/domain/repositories/chat_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatViewModel extends GetxController {
  ChatViewModel({ChatRepository? repository})
    : _repository = repository ?? Get.find<ChatRepository>();

  final ChatRepository _repository;

  final chatController = TextEditingController();
  final scrollController = ScrollController();
  final messages = <ChatMessage>[].obs;
  final isSending = false.obs;

  String? conversationId;
  CancelToken? _cancelToken;

  bool get hasMessages => messages.isNotEmpty;

  final _speechToTextService = SpeechToTextService();
  final isSpeechAvailable = false.obs;
  final recognizedText = ''.obs;
  final isListening = false.obs;
  final isTranscribing = false.obs;
  final voiceLevels = <double>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initSpeechToText();
  }

  void _initSpeechToText() async {
    isSpeechAvailable.value = await _speechToTextService.init();

    if (!isSpeechAvailable.value) {
      Get.snackbar(
        'Error',
        'Speech recognition is not available on this device.',
      );
    }
  }

  Future<void> startListening() async {
    if (isListening.value) return;

    isListening.value = true;
    voiceLevels.clear();

    try {
      final started = await _speechToTextService.startListening(
        onTextChanged: (text) {
          chatController.text = text;
          chatController.selection = TextSelection.fromPosition(
            TextPosition(offset: chatController.text.length),
          );
        },
        onSoundLevelChanged: (level) {
          final normalized = _normalizeSoundLevel(level);

          voiceLevels.add(normalized);

          if (voiceLevels.length > 80) {
            voiceLevels.removeAt(0);
          }
        },
      );

      if (!started) {
        isListening.value = false;
      }
    } catch (_) {
      isListening.value = false;
      voiceLevels.clear();
      rethrow;
    }
  }

  Future<void> stopListening() async {
    if (!isListening.value) return;

    try {
      isListening.value = false;
      isTranscribing.value = true;
      await _speechToTextService.stopListening();
    } finally {
      isTranscribing.value = false;
      voiceLevels.clear();
    }
  }

  Future<void> cancelListening() async {
    if (!isListening.value) return;

    try {
      await _speechToTextService.cancelListening();
    } finally {
      isListening.value = false;
      isTranscribing.value = false;
      voiceLevels.clear();
      chatController.clear();
    }
  }

  double _normalizeSoundLevel(double level) {
    return ((level + 2) / 12).clamp(0.08, 1.0);
  }

  Future<void> sendCurrentMessage() async {
    final question = chatController.text.trim();
    if (question.isEmpty || isSending.value) {
      return;
    }

    chatController.clear();

    await sendMessage(question);
  }

  Future<void> sendMessage(String question) async {
    if (question.trim().isEmpty || isSending.value) {
      return;
    }

    final userMessage = ChatMessage(
      id: _nextId('user'),
      role: ChatMessageRole.user,
      text: question.trim(),
    );
    final assistantMessage = ChatMessage(
      id: _nextId('assistant'),
      role: ChatMessageRole.assistant,
      text: '',
      isStreaming: true,
    );

    messages.addAll([userMessage, assistantMessage]);
    isSending.value = true;
    _cancelToken = CancelToken();
    // _scrollToBottom();

    try {
      await for (final event in _repository.streamChat(
        question: question.trim(),
        conversationId: conversationId,
        cancelToken: _cancelToken,
      )) {
        _handleStreamEvent(assistantMessage.id, event.event, event.data);
      }
    } catch (error) {
      if (error is DioException && CancelToken.isCancel(error)) {
        _finishAssistantMessage(assistantMessage.id);
        return;
      }
      _appendAssistantText(
        assistantMessage.id,
        '\n\nSorry, I could not connect to TripGenie. Please try again.',
      );
      _finishAssistantMessage(assistantMessage.id);
    } finally {
      isSending.value = false;
      _cancelToken = null;
      // _scrollToBottom();
    }
  }

  void stopStreaming() {
    _cancelToken?.cancel('User stopped generation.');
    isSending.value = false;
  }

  void _handleStreamEvent(String assistantId, String event, Object? data) {
    final map = data is Map ? Map<String, dynamic>.from(data) : null;

    switch (event) {
      case 'conversation':
        conversationId = map?['conversationId']?.toString() ?? conversationId;
        break;
      case 'token':
        _appendAssistantText(assistantId, map?['text']?.toString() ?? '');
        break;
      case 'sources':
        if (data is List) {
          _updateAssistantSources(
            assistantId,
            data
                .whereType<Map>()
                .map(
                  (source) => ResourceSummary.fromJson(
                    Map<String, dynamic>.from(source),
                  ),
                )
                .toList(),
          );
        }
        break;
      case 'comparison':
        if (data is List) {
          _updateAssistantComparison(assistantId, _parseComparison(data));
        }
        break;
      case 'done':
        conversationId = map?['conversationId']?.toString() ?? conversationId;
        final answer = map?['answer']?.toString();
        final sources = map?['sources'];
        final comparison = map?['comparison'];
        final quickQuestions = map?['quickQuestions'];
        _updateAssistantFinalData(
          assistantId,
          answer: answer,
          sources: sources is List
              ? sources
                    .whereType<Map>()
                    .map(
                      (source) => ResourceSummary.fromJson(
                        Map<String, dynamic>.from(source),
                      ),
                    )
                    .toList()
              : null,
          comparison: comparison is List ? _parseComparison(comparison) : null,
          quickQuestions: quickQuestions is List
              ? quickQuestions.map((question) => question.toString()).toList()
              : null,
        );
        break;
      case 'error':
        _appendAssistantText(
          assistantId,
          '\n\n${map?['message']?.toString() ?? 'Something went wrong.'}',
        );
        _finishAssistantMessage(assistantId);
        break;
    }
  }

  void _appendAssistantText(String assistantId, String text) {
    if (text.isEmpty) {
      return;
    }
    final index = messages.indexWhere((message) => message.id == assistantId);
    if (index == -1) {
      return;
    }
    final current = messages[index];
    messages[index] = current.copyWith(text: current.text + text);
    // _scrollToBottom();
  }

  void _updateAssistantSources(
    String assistantId,
    List<ResourceSummary> sources,
  ) {
    final index = messages.indexWhere((message) => message.id == assistantId);
    if (index == -1) {
      return;
    }
    messages[index] = messages[index].copyWith(sources: sources);
  }

  void _updateAssistantComparison(
    String assistantId,
    List<ComparisonItem> comparison,
  ) {
    final index = messages.indexWhere((message) => message.id == assistantId);
    if (index == -1) {
      return;
    }
    messages[index] = messages[index].copyWith(comparison: comparison);
  }

  void _updateAssistantFinalData(
    String assistantId, {
    String? answer,
    List<ResourceSummary>? sources,
    List<ComparisonItem>? comparison,
    List<String>? quickQuestions,
  }) {
    final index = messages.indexWhere((message) => message.id == assistantId);
    if (index == -1) {
      return;
    }
    messages[index] = messages[index].copyWith(
      text: answer == null || answer.isEmpty ? null : answer,
      sources: sources,
      comparison: comparison,
      quickQuestions: quickQuestions,
      isStreaming: false,
    );
  }

  List<ComparisonItem> _parseComparison(List<Object?> data) {
    return data
        .whereType<Map>()
        .map((item) => ComparisonItem.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  void _finishAssistantMessage(String assistantId) {
    final index = messages.indexWhere((message) => message.id == assistantId);
    if (index == -1) {
      return;
    }
    messages[index] = messages[index].copyWith(isStreaming: false);
  }

  // void _scrollToBottom() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (!scrollController.hasClients) {
  //       return;
  //     }
  //     scrollController.animateTo(
  //       scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 220),
  //       curve: Curves.easeOutCubic,
  //     );
  //   });
  // }

  String _nextId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
  }

  @override
  void onClose() {
    _cancelToken?.cancel();
    chatController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
