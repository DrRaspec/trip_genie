import 'package:ai_chat_bot/feature/chat/data/models/comparison_item.dart';
import 'package:ai_chat_bot/feature/chat/data/models/resource_summary.dart';

enum ChatMessageRole { user, assistant }

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    this.isStreaming = false,
    this.sources = const [],
    this.comparison = const [],
    this.quickQuestions = const [],
  });

  final String id;
  final ChatMessageRole role;
  final String text;
  final bool isStreaming;
  final List<ResourceSummary> sources;
  final List<ComparisonItem> comparison;
  final List<String> quickQuestions;

  ChatMessage copyWith({
    String? text,
    bool? isStreaming,
    List<ResourceSummary>? sources,
    List<ComparisonItem>? comparison,
    List<String>? quickQuestions,
  }) {
    return ChatMessage(
      id: id,
      role: role,
      text: text ?? this.text,
      isStreaming: isStreaming ?? this.isStreaming,
      sources: sources ?? this.sources,
      comparison: comparison ?? this.comparison,
      quickQuestions: quickQuestions ?? this.quickQuestions,
    );
  }
}
