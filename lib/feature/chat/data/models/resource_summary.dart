class ResourceSummary {
  const ResourceSummary({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.priceLabel,
  });

  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String imageUrl;
  final double? rating;
  final String priceLabel;

  factory ResourceSummary.fromJson(Map<String, dynamic> json) {
    final price = json['priceFrom'];
    final currency = json['currency']?.toString();
    final imageUrl = json['imageUrl']?.toString() ?? '';

    return ResourceSummary(
      id: json['resourceId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      imageUrl: imageUrl.contains('photo-1540521338287-41700207dee6')
          ? ''
          : imageUrl,
      rating: (json['rating'] as num?)?.toDouble(),
      priceLabel: price == null
          ? ''
          : '${currency == null || currency.isEmpty ? '' : '$currency '}$price',
    );
  }
}
