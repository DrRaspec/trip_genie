class ComparisonItem {
  const ComparisonItem({
    required this.id,
    required this.title,
    required this.category,
    required this.priceLabel,
    required this.duration,
    required this.rating,
    required this.bestFor,
  });

  final String id;
  final String title;
  final String category;
  final String priceLabel;
  final String duration;
  final double? rating;
  final String bestFor;

  factory ComparisonItem.fromJson(Map<String, dynamic> json) {
    final price = json['priceFrom'];
    final currency = json['currency']?.toString();

    return ComparisonItem(
      id: json['resourceId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      priceLabel: price == null
          ? ''
          : '${currency == null || currency.isEmpty ? '' : '$currency '}$price',
      duration: json['duration']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble(),
      bestFor: json['bestFor']?.toString() ?? '',
    );
  }
}
