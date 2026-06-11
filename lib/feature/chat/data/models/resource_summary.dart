class ResourceSummary {
  const ResourceSummary({
    required this.id,
    required this.slug,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.sourceType,
    required this.priceFrom,
    required this.currency,
    required this.duration,
    required this.imageUrl,
    required this.deepLink,
    required this.rating,
    required this.reason,
  });

  final String id;
  final String slug;
  final String title;
  final String subtitle;
  final String category;
  final String sourceType;
  final double? priceFrom;
  final String currency;
  final String duration;
  final String imageUrl;
  final String deepLink;
  final double? rating;
  final String reason;

  String get priceLabel {
    if (priceFrom == null) {
      return '';
    }

    final amount = priceFrom! % 1 == 0
        ? priceFrom!.toStringAsFixed(0)
        : priceFrom!.toStringAsFixed(2);

    return currency.isEmpty ? amount : '$currency $amount';
  }

  factory ResourceSummary.fromJson(Map<String, dynamic> json) {
    final imageUrl = json['imageUrl']?.toString() ?? '';

    return ResourceSummary(
      id: json['resourceId']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      sourceType: json['sourceType']?.toString() ?? '',
      priceFrom: (json['priceFrom'] as num?)?.toDouble(),
      currency: json['currency']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      imageUrl: imageUrl.contains('photo-1540521338287-41700207dee6')
          ? ''
          : imageUrl,
      deepLink: json['deepLink']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble(),
      reason: json['reason']?.toString() ?? '',
    );
  }
}
