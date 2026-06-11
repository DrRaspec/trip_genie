import 'package:ai_chat_bot/feature/chat/data/models/resource_detail.dart';
import 'package:ai_chat_bot/feature/chat/presentation/view/widget/resource_quick_facts.dart';
import 'package:ai_chat_bot/feature/chat/presentation/view_model/source_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SourceDetailView extends GetView<SourceDetailViewModel> {
  const SourceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: Obx(() {
        final item = controller.item.value;

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (item == null) {
          return _EmptyDetailState(onBack: () => Navigator.pop(context));
        }

        return _DetailContent(item: item);
      }),
      bottomNavigationBar: Obx(() {
        final item = controller.item.value;
        if (controller.isLoading.value || item == null) {
          return const SizedBox.shrink();
        }

        return _DetailBottomBar(item: item);
      }),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.item});

  final ResourceDetail item;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _DetailHeader(item: item),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _MainInfoCard(item: item),
              ResourceQuickFacts(item: item),
              if (item.hasFullDetail) _OverviewSection(item: item),
              if (item.features.isNotEmpty) _FeaturesSection(item: item),
              _TripPlanSection(item: item),
              if (item.hasLocation || item.hasCoordinate)
                _LocationSection(item: item),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyDetailState extends StatelessWidget {
  const _EmptyDetailState({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _CircleIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: onBack,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'No detail found',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff6B7280),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.item});

  final ResourceDetail item;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 310,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: _CircleIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.pop(context),
      ),
      actions: [
        _CircleIconButton(icon: Icons.favorite_border_rounded, onTap: () {}),
        const SizedBox(width: 10),
        _CircleIconButton(icon: Icons.share_rounded, onTap: () {}),
        const SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _HeroImage(item: item),
            const _HeaderScrim(),
            Positioned(
              left: 20,
              right: 20,
              bottom: 28,
              child: _HeaderTitle(item: item),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.item});

  final ResourceDetail item;

  @override
  Widget build(BuildContext context) {
    if (!item.hasImage) {
      return const _HeroPlaceholder();
    }

    return Image.network(
      item.imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const _HeroPlaceholder(),
    );
  }
}

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0B7DFF), Color(0xff00A8E8), Color(0xff45D6B5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: 80,
            child: Icon(
              Icons.waves_rounded,
              size: 220,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            left: 24,
            top: 120,
            child: Icon(
              Icons.beach_access_rounded,
              size: 90,
              color: Colors.white.withValues(alpha: 0.25),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderScrim extends StatelessWidget {
  const _HeaderScrim();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.25),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.50),
          ],
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({required this.item});

  final ResourceDetail item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CategoryBadge(label: item.categoryLabel),
        const SizedBox(height: 12),
        Text(
          item.titleLabel,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        if (item.hasLocation) ...[
          const SizedBox(height: 8),
          _HeaderLocation(label: item.locationLabel),
        ],
      ],
    );
  }
}

class _HeaderLocation extends StatelessWidget {
  const _HeaderLocation({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on_rounded, color: Colors.white, size: 18),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xff0077E6),
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _MainInfoCard extends StatelessWidget {
  const _MainInfoCard({required this.item});

  final ResourceDetail item;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -16),
      child: _SectionSurface(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _MainInfoTitle(item: item)),
                if (item.hasRating) _RatingBadge(label: item.ratingLabel),
              ],
            ),
            if (item.hasDescription) ...[
              const SizedBox(height: 12),
              Text(
                item.descriptionLabel,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.5,
                  color: Color(0xff5F6B7A),
                ),
              ),
            ],
            if (item.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              _TagWrap(tags: item.tags),
            ],
          ],
        ),
      ),
    );
  }
}

class _MainInfoTitle extends StatelessWidget {
  const _MainInfoTitle({required this.item});

  final ResourceDetail item;

  @override
  Widget build(BuildContext context) {
    final label = item.subtitleLabel.isEmpty
        ? item.categoryLabel
        : item.subtitleLabel;

    return Text(
      label,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xff1F2937),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xff0077E6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Colors.white, size: 17),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagWrap extends StatelessWidget {
  const _TagWrap({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) => _TagChip(label: tag)).toList(),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xffEAF4FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xff0077E6),
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _OverviewSection extends StatelessWidget {
  const _OverviewSection({required this.item});

  final ResourceDetail item;

  static const _highlights = [
    _HighlightData(
      icon: Icons.hotel_rounded,
      title: 'Stay planning',
      subtitle: 'Compare convenience, comfort, and nearby activities.',
    ),
    _HighlightData(
      icon: Icons.beach_access_rounded,
      title: 'Beach access',
      subtitle: 'Good for choosing the right area near the coast.',
    ),
    _HighlightData(
      icon: Icons.explore_rounded,
      title: 'Local discovery',
      subtitle: 'Useful for planning food, transport, and short trips.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _DetailSection(
      title: 'Overview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.fullDetailLabel,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.6,
              color: Color(0xff4B5563),
            ),
          ),
          const SizedBox(height: 16),
          for (final highlight in _highlights) ...[
            _HighlightRow(data: highlight),
            if (highlight != _highlights.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _HighlightData {
  const _HighlightData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

class _HighlightRow extends StatelessWidget {
  const _HighlightRow({required this.data});

  final _HighlightData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xffEAF4FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(data.icon, color: const Color(0xff0077E6), size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  color: Color(0xff1F2937),
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                data.subtitle,
                style: const TextStyle(
                  color: Color(0xff6B7280),
                  height: 1.4,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection({required this.item});

  final ResourceDetail item;

  @override
  Widget build(BuildContext context) {
    return _DetailSection(
      title: 'What you will enjoy',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: item.features
            .map((feature) => _FeatureChip(label: feature))
            .toList(),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xffF2F8FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffDCEEFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xff0077E6),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xff1F2937),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TripPlanSection extends StatelessWidget {
  const _TripPlanSection({required this.item});

  final ResourceDetail item;

  @override
  Widget build(BuildContext context) {
    final city = item.city?.trim().isNotEmpty == true
        ? item.city!.trim()
        : 'the area';
    final days = [
      _TimelineData(
        day: 'Day 1',
        title: 'Arrive in $city',
        description:
            'Check in, explore the nearby area, and enjoy a relaxed first evening.',
      ),
      const _TimelineData(
        day: 'Day 2',
        title: 'Explore nearby highlights',
        description:
            'Spend the day around beaches, food spots, viewpoints, or local activities.',
      ),
      const _TimelineData(
        day: 'Day 3',
        title: 'Slow morning and return',
        description:
            'Enjoy breakfast, take final photos, then prepare your transport back.',
      ),
    ];

    return _DetailSection(
      title: 'Suggested plan',
      child: Column(
        children: [
          for (int i = 0; i < days.length; i++)
            _TimelineItem(data: days[i], isLast: i == days.length - 1),
        ],
      ),
    );
  }
}

class _TimelineData {
  const _TimelineData({
    required this.day,
    required this.title,
    required this.description,
  });

  final String day;
  final String title;
  final String description;
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.data, required this.isLast});

  final _TimelineData data;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xff0077E6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.flag_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 70, color: const Color(0xffDCEEFF)),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.day,
                  style: const TextStyle(
                    color: Color(0xff0077E6),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.title,
                  style: const TextStyle(
                    color: Color(0xff1F2937),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data.description,
                  style: const TextStyle(
                    color: Color(0xff6B7280),
                    height: 1.45,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationSection extends StatelessWidget {
  const _LocationSection({required this.item});

  final ResourceDetail item;

  @override
  Widget build(BuildContext context) {
    return _DetailSection(
      title: 'Location',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MapPreview(),
          if (item.hasLocation) ...[
            const SizedBox(height: 14),
            Text(
              item.locationLabel,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xff1F2937),
              ),
            ),
          ],
          if (item.hasCoordinate) ...[
            const SizedBox(height: 5),
            Text(
              item.coordinateLabel,
              style: const TextStyle(fontSize: 13, color: Color(0xff6B7280)),
            ),
          ],
        ],
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xffDFF1FF), Color(0xffF5FBFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.map_rounded,
              size: 90,
              color: const Color(0xff0077E6).withValues(alpha: 0.18),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color(0xff0077E6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailBottomBar extends StatelessWidget {
  const _DetailBottomBar({required this.item});

  final ResourceDetail item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: item.hasPrice
                ? _PriceSummary(label: item.priceLabel)
                : const _PlanTripLabel(),
          ),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0077E6),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'View Trip',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  const _PriceSummary({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'From\n',
            style: TextStyle(
              color: Color(0xff8A95A3),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: label,
            style: const TextStyle(
              color: Color(0xffFF6B00),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanTripLabel extends StatelessWidget {
  const _PlanTripLabel();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Plan your trip',
      style: TextStyle(
        color: Color(0xff1F2937),
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _SectionSurface(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SectionSurface extends StatelessWidget {
  const _SectionSurface({required this.child, this.margin = EdgeInsets.zero});

  final Widget child;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: child,
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xff1F2937), size: 18),
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}
