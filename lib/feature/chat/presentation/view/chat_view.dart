import 'package:ai_chat_bot/app/theme/app_theme.dart';
import 'package:ai_chat_bot/core/utils/extension.dart';
import 'package:ai_chat_bot/feature/chat/data/models/chat_message.dart';
import 'package:ai_chat_bot/feature/chat/data/models/comparison_item.dart';
import 'package:ai_chat_bot/feature/chat/data/models/resource_summary.dart';
import 'package:ai_chat_bot/feature/chat/presentation/view/widget/chat_app_bar.dart';
import 'package:ai_chat_bot/feature/chat/presentation/view_model/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChatView extends GetView<ChatViewModel> {
  const ChatView({super.key});

  static const _questions = [
    _QuestionCardData(
      icon: Icons.place_outlined,
      label: 'Attractions',
      labelColor: Color(0xFF008D95),
      question:
          'Which districts in Guangzhou are best for exploring cultural attra...',
    ),
    _QuestionCardData(
      icon: Icons.emoji_objects_outlined,
      label: 'Inspiration',
      labelColor: Color(0xFFD64C10),
      question:
          'How early should I arrive at the airport for a domestic flight?',
    ),
    _QuestionCardData(
      icon: Icons.emoji_objects_outlined,
      label: 'Inspiration',
      labelColor: Color(0xFFD64C10),
      question: 'How do I book a rental car for my trip?',
    ),
    _QuestionCardData(
      icon: Icons.emoji_objects_outlined,
      label: 'Inspiration',
      labelColor: Color(0xFFD64C10),
      question: 'Can I rent a car with an international driver\'s license?',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ChatAppBar(),
      body: Stack(
        children: [
          Obx(
            () => CustomScrollView(
              controller: controller.scrollController,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    12,
                    24,
                    context.bottomPadding + 172,
                  ),
                  sliver: SliverList.list(
                    children: [
                      if (!controller.hasMessages)
                        _WelcomeContent(
                          questions: _questions,
                          onQuestionTap: controller.sendMessage,
                        )
                      else ...[
                        const Center(
                          child: Text(
                            'Scroll down to see the history',
                            style: TextStyle(
                              color: Color(0xFF7B8494),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        for (final message in controller.messages) ...[
                          _ChatMessageView(
                            message: message,
                            onQuickQuestionTap: controller.sendMessage,
                          ),
                          const SizedBox(height: 18),
                        ],
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomComposer(controller: controller),
          ),
        ],
      ),
    );
  }
}

class _WelcomeContent extends StatelessWidget {
  const _WelcomeContent({required this.questions, required this.onQuestionTap});

  final List<_QuestionCardData> questions;
  final ValueChanged<String> onQuestionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Hi there!',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 26),
        GridView.builder(
          itemCount: questions.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 18,
            childAspectRatio: 1.8,
          ),
          itemBuilder: (context, index) {
            return _QuestionCard(
              data: questions[index],
              onTap: () => onQuestionTap(questions[index].question),
            );
          },
        ),
        const SizedBox(height: 64),
        const Center(child: _RefreshQuestionsButton()),
      ],
    );
  }
}

class _QuestionCardData {
  const _QuestionCardData({
    required this.icon,
    required this.label,
    required this.labelColor,
    required this.question,
  });

  final IconData icon;
  final String label;
  final Color labelColor;
  final String question;
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.data, required this.onTap});

  final _QuestionCardData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD6DAE2), width: 1.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(data.icon, color: data.labelColor, size: 20),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      data.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: data.labelColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  data.question,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 18,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatMessageView extends StatelessWidget {
  const _ChatMessageView({
    required this.message,
    required this.onQuickQuestionTap,
  });

  final ChatMessage message;
  final ValueChanged<String> onQuickQuestionTap;

  @override
  Widget build(BuildContext context) {
    return switch (message.role) {
      ChatMessageRole.user => Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xFF5A6272),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
      ChatMessageRole.assistant => _AssistantMessage(
        message: message,
        onQuickQuestionTap: onQuickQuestionTap,
      ),
    };
  }
}

class _AssistantMessage extends StatelessWidget {
  const _AssistantMessage({
    required this.message,
    required this.onQuickQuestionTap,
  });

  final ChatMessage message;
  final ValueChanged<String> onQuickQuestionTap;

  @override
  Widget build(BuildContext context) {
    final text = message.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.isStreaming && text.isEmpty)
          const _ProcessCard()
        else ...[
          if (message.isStreaming) const _ProcessCard(compact: true),
          MarkdownBody(
            data: text.isEmpty ? 'Thinking...' : text,
            selectable: false,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 20,
                height: 1.45,
                fontWeight: FontWeight.w400,
              ),
              strong: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              h1: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 26,
                height: 1.2,
                fontWeight: FontWeight.w800,
              ),
              h2: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 23,
                height: 1.25,
                fontWeight: FontWeight.w800,
              ),
              h3: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 21,
                height: 1.25,
                fontWeight: FontWeight.w800,
              ),
              listBullet: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 20,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
              a: const TextStyle(
                color: Color(0xFF2F5BFF),
                decoration: TextDecoration.underline,
                fontSize: 20,
                height: 1.45,
              ),
            ),
          ),
        ],
        if (message.sources.isNotEmpty) ...[
          const SizedBox(height: 18),
          _SourceStrip(sources: message.sources),
        ],
        if (message.comparison.isNotEmpty) ...[
          const SizedBox(height: 18),
          _ComparisonSection(items: message.comparison),
        ],
        if (message.quickQuestions.isNotEmpty) ...[
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final question in message.quickQuestions)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width - 48,
                  ),
                  child: ActionChip(
                    label: Text(
                      question,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () => onQuickQuestionTap(question),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFD6DAE2)),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ProcessCard extends StatelessWidget {
  const _ProcessCard({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: compact ? 16 : 0),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: Color(0xFF2F5BFF),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            compact ? 'Process completed' : 'TripGenie is thinking...',
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonSection extends StatelessWidget {
  const _ComparisonSection({required this.items});

  final List<ComparisonItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD6DAE2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Comparison',
                    style: TextStyle(
                      color: Color(0xFF7B8494),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Copy table',
                  onPressed: () => _copyTable(context),
                  icon: const Icon(
                    Icons.copy_all_outlined,
                    color: Color(0xFF7B8494),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFD6DAE2)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF2F4F8)),
              dataRowMinHeight: 84,
              dataRowMaxHeight: 116,
              columnSpacing: 22,
              horizontalMargin: 16,
              columns: const [
                DataColumn(label: Text('Option')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Duration')),
                DataColumn(label: Text('Best for')),
              ],
              rows: [
                for (final item in items)
                  DataRow(
                    cells: [
                      DataCell(_ComparisonOption(item: item)),
                      DataCell(
                        Text(item.priceLabel.isEmpty ? '-' : item.priceLabel),
                      ),
                      DataCell(
                        Text(item.duration.isEmpty ? '-' : item.duration),
                      ),
                      DataCell(
                        SizedBox(
                          width: 210,
                          child: Text(
                            item.bestFor,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyTable(BuildContext context) async {
    final table = [
      ['Option', 'Category', 'Rating', 'Price', 'Duration', 'Best for'],
      for (final item in items)
        [
          item.title,
          item.category,
          item.rating == null ? '' : item.rating!.toStringAsFixed(1),
          item.priceLabel,
          item.duration,
          item.bestFor,
        ],
    ].map((row) => row.map(_cleanTableCell).join('\t')).join('\n');

    await Clipboard.setData(ClipboardData(text: table));

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Comparison table copied')));
  }

  String _cleanTableCell(String value) {
    return value.replaceAll(RegExp(r'[\t\r\n]+'), ' ').trim();
  }
}

class _ComparisonOption extends StatelessWidget {
  const _ComparisonOption({required this.item});

  final ComparisonItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            [
              if (item.category.isNotEmpty) item.category,
              if (item.rating != null)
                '${item.rating!.toStringAsFixed(1)} stars',
            ].join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF5D6675),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceStrip extends StatelessWidget {
  const _SourceStrip({required this.sources});

  final List<ResourceSummary> sources;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E5EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.travel_explore, size: 22),
              const SizedBox(width: 8),
              Text(
                'Sources found',
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8EBF1),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Text('${sources.length}'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: sources.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _SourceCard(source: sources[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({required this.source});

  final ResourceSummary source;

  @override
  Widget build(BuildContext context) {
    final fallbackAsset = _mockupAssetFor(source);

    return SizedBox(
      width: 150,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE1E5EC)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: source.imageUrl.isEmpty
                    ? _SourceImage(assetPath: fallbackAsset)
                    : Image.network(
                        source.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            _SourceImage(assetPath: fallbackAsset),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      source.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 14,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      source.priceLabel.isEmpty
                          ? source.category
                          : source.priceLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF5D6675),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceImage extends StatelessWidget {
  const _SourceImage({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(assetPath, fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.02),
                Colors.black.withValues(alpha: 0.18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String _mockupAssetFor(ResourceSummary source) {
  final text = '${source.title} ${source.subtitle} ${source.category}'
      .toLowerCase();

  if (text.contains('kampot') ||
      text.contains('kep') ||
      text.contains('bokor') ||
      text.contains('pepper')) {
    return 'assets/images/mockups/kampot.jpg';
  }
  if (text.contains('koh') ||
      text.contains('island') ||
      text.contains('beach') ||
      text.contains('ferry')) {
    return 'assets/images/mockups/island.jpg';
  }
  if (text.contains('food') ||
      text.contains('cooking') ||
      text.contains('crab') ||
      text.contains('market')) {
    return 'assets/images/mockups/food.jpg';
  }
  if (text.contains('phnom penh') ||
      text.contains('palace') ||
      text.contains('museum') ||
      text.contains('transfer') ||
      text.contains('bus') ||
      text.contains('taxi')) {
    return 'assets/images/mockups/city.jpg';
  }
  if (text.contains('angkor') ||
      text.contains('temple') ||
      text.contains('siem reap')) {
    return 'assets/images/mockups/temple.jpg';
  }

  return 'assets/images/mockups/temple.jpg';
}

class _RefreshQuestionsButton extends StatelessWidget {
  const _RefreshQuestionsButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.refresh_rounded, size: 24),
      label: const Text('Refresh questions'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF5D6675),
        side: const BorderSide(color: Color(0xFFD6DAE2), width: 1.4),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _BottomComposer extends StatelessWidget {
  const _BottomComposer({required this.controller});

  final ChatViewModel controller;

  static const _actions = [
    (Icons.hotel_class_outlined, 'Compare hotels'),
    (Icons.camera_alt_outlined, 'Recognize image'),
    (Icons.maps_home_work_outlined, 'Live help'),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6FA),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      for (final action in _actions) ...[
                        _BottomActionChip(icon: action.$1, label: action.$2),
                        const SizedBox(width: 10),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 64),
                    padding: const EdgeInsets.fromLTRB(18, 6, 8, 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.chatController,
                            enabled: !controller.isSending.value,
                            onSubmitted: (_) => controller.sendCurrentMessage(),
                            minLines: 1,
                            maxLines: 4,
                            textInputAction: TextInputAction.send,
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: const InputDecoration(
                              filled: false,
                              hintText: 'Ask me anything about travel',
                              hintStyle: TextStyle(
                                color: Color(0xFF7B8494),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Voice input',
                          onPressed: () {},
                          icon: const Icon(
                            Icons.mic_none_rounded,
                            color: Color(0xFF111827),
                            size: 34,
                          ),
                        ),
                        IconButton.filled(
                          tooltip: controller.isSending.value ? 'Stop' : 'Send',
                          onPressed: controller.isSending.value
                              ? controller.stopStreaming
                              : controller.sendCurrentMessage,
                          style: IconButton.styleFrom(
                            backgroundColor: controller.isSending.value
                                ? const Color(0xFF2F5BFF)
                                : const Color(0xFFC6CBD4),
                            foregroundColor: Colors.white,
                            fixedSize: const Size(54, 54),
                          ),
                          icon: Icon(
                            controller.isSending.value
                                ? Icons.stop_rounded
                                : Icons.send_rounded,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomActionChip extends StatelessWidget {
  const _BottomActionChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 26),
      label: Text(label, maxLines: 1),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF111827),
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFD6DAE2), width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}
