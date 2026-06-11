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
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.item.value == null) {
          return _emptyState(context);
        }

        return CustomScrollView(
          slivers: [
            _buildHeader(context),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildMainInfo(),
                  _buildQuickFacts(),
                  if (controller.item.value!.hasFullDetail) _buildOverview(),
                  if (controller.item.value!.features.isNotEmpty)
                    _buildFeatures(),
                  _buildTripPlan(),
                  if (controller.item.value!.hasLocation ||
                      controller.item.value!.hasCoordinate)
                    _buildLocation(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value || controller.item.value == null) {
          return const SizedBox.shrink();
        }

        return _buildBottomBar();
      }),
    );
  }

  Widget _emptyState(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _circleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
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

  Widget _buildHeader(BuildContext context) {
    final item = controller.item.value!;

    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 310,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: _circleButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.pop(context),
      ),
      actions: [
        _circleButton(icon: Icons.favorite_border_rounded, onTap: () {}),
        const SizedBox(width: 10),
        _circleButton(icon: Icons.share_rounded, onTap: () {}),
        const SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildHeroImage(),
            Container(
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
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _categoryBadge(),
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
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.locationLabel,
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
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    final item = controller.item.value!;

    if (item.hasImage) {
      return Image.network(
        item.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _heroPlaceholder(),
      );
    }

    return _heroPlaceholder();
  }

  Widget _heroPlaceholder() {
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

  Widget _buildMainInfo() {
    final item = controller.item.value!;

    return Transform.translate(
      offset: const Offset(0, -16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(18),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.subtitleLabel.isEmpty
                        ? item.categoryLabel
                        : item.subtitleLabel,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff1F2937),
                    ),
                  ),
                ),
                if (item.hasRating) _ratingBox(),
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
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffEAF4FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Color(0xff0077E6),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFacts() {
    final item = controller.item.value!;

    final facts = <Widget>[];

    if (item.hasPrice) {
      facts.add(
        Expanded(
          child: _factCard(
            icon: Icons.payments_rounded,
            title: 'From',
            value: item.priceLabel,
          ),
        ),
      );
    }

    if (item.durationLabel.isNotEmpty) {
      facts.add(
        Expanded(
          child: _factCard(
            icon: Icons.schedule_rounded,
            title: 'Duration',
            value: item.durationLabel,
          ),
        ),
      );
    }

    if (item.hasRating) {
      facts.add(
        Expanded(
          child: _factCard(
            icon: Icons.star_rounded,
            title: 'Rating',
            value: item.ratingLabel,
          ),
        ),
      );
    }

    if (facts.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: [
          for (int i = 0; i < facts.length; i++) ...[
            if (i != 0) const SizedBox(width: 10),
            facts[i],
          ],
        ],
      ),
    );
  }

  Widget _factCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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

  Widget _buildOverview() {
    final item = controller.item.value!;

    return _sectionCard(
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
          _highlightRow(
            icon: Icons.hotel_rounded,
            title: 'Stay planning',
            subtitle: 'Compare convenience, comfort, and nearby activities.',
          ),
          const SizedBox(height: 12),
          _highlightRow(
            icon: Icons.beach_access_rounded,
            title: 'Beach access',
            subtitle: 'Good for choosing the right area near the coast.',
          ),
          const SizedBox(height: 12),
          _highlightRow(
            icon: Icons.explore_rounded,
            title: 'Local discovery',
            subtitle: 'Useful for planning food, transport, and short trips.',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    final item = controller.item.value!;

    return _sectionCard(
      title: 'What you will enjoy',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: item.features.map((feature) {
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
                  feature,
                  style: const TextStyle(
                    color: Color(0xff1F2937),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTripPlan() {
    final item = controller.item.value!;
    final city = item.city?.trim().isNotEmpty == true
        ? item.city!.trim()
        : 'the area';

    return _sectionCard(
      title: 'Suggested plan',
      child: Column(
        children: [
          _timelineItem(
            day: 'Day 1',
            title: 'Arrive in $city',
            description:
                'Check in, explore the nearby area, and enjoy a relaxed first evening.',
            isLast: false,
          ),
          _timelineItem(
            day: 'Day 2',
            title: 'Explore nearby highlights',
            description:
                'Spend the day around beaches, food spots, viewpoints, or local activities.',
            isLast: false,
          ),
          _timelineItem(
            day: 'Day 3',
            title: 'Slow morning and return',
            description:
                'Enjoy breakfast, take final photos, then prepare your transport back.',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    final item = controller.item.value!;

    return _sectionCard(
      title: 'Location',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
          ),
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

  Widget _buildBottomBar() {
    final item = controller.item.value!;

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
                ? RichText(
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
                          text: item.priceLabel,
                          style: const TextStyle(
                            color: Color(0xffFF6B00),
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  )
                : const Text(
                    'Plan your trip',
                    style: TextStyle(
                      color: Color(0xff1F2937),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
          ),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Open booking, deep link, map, or chat action.
                // Example:
                // final deepLink = item.deepLink;
              },
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

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
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

  Widget _highlightRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
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
          child: Icon(icon, color: const Color(0xff0077E6), size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xff1F2937),
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
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

  Widget _timelineItem({
    required String day,
    required String title,
    required String description,
    required bool isLast,
  }) {
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
                  day,
                  style: const TextStyle(
                    color: Color(0xff0077E6),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff1F2937),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
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

  Widget _ratingBox() {
    final item = controller.item.value!;

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
            item.ratingLabel,
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

  Widget _categoryBadge() {
    final item = controller.item.value!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        item.categoryLabel,
        style: const TextStyle(
          color: Color(0xff0077E6),
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
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
}
