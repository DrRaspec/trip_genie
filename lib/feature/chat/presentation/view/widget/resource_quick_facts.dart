import 'package:ai_chat_bot/feature/chat/data/models/resource_detail.dart';
import 'package:flutter/material.dart';

class ResourceQuickFacts extends StatelessWidget {
  const ResourceQuickFacts({super.key, required this.item});

  final ResourceDetail item;

  @override
  Widget build(BuildContext context) {
    final facts = <Widget>[];

    if (item.hasPrice) {
      facts.add(
        _FactCard(
          icon: Icons.payments_rounded,
          title: 'From',
          value: item.priceLabel,
        ),
      );
    }

    if (item.durationLabel.isNotEmpty) {
      facts.add(
        _FactCard(
          icon: Icons.schedule_rounded,
          title: 'Duration',
          value: item.durationLabel,
        ),
      );
    }

    if (item.hasRating) {
      facts.add(
        _FactCard(
          icon: Icons.star_rounded,
          title: 'Rating',
          value: item.ratingLabel,
        ),
      );
    }

    if (facts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: [
          for (int i = 0; i < facts.length; i++) ...[
            Expanded(child: facts[i]),
            if (i != facts.length - 1) const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  const _FactCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xff0077E6), size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff8A95A3),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff1F2937),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
