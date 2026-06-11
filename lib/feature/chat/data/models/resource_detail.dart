class ResourceDetail {
  const ResourceDetail({
    this.id,
    this.slug,
    this.title,
    this.subtitle,
    this.description,
    this.fullDetail,
    this.country,
    this.province,
    this.city,
    this.category,
    this.sourceType,
    this.priceFrom,
    this.currency,
    this.duration,
    this.imageUrl,
    this.deepLink,
    this.tags = const [],
    this.features = const [],
    this.rating,
    this.latitude,
    this.longitude,
  });

  final String? id;
  final String? slug;
  final String? title;
  final String? subtitle;
  final String? description;
  final String? fullDetail;
  final String? country;
  final String? province;
  final String? city;
  final String? category;
  final String? sourceType;
  final double? priceFrom;
  final String? currency;
  final String? duration;
  final String? imageUrl;
  final String? deepLink;
  final List<String> tags;
  final List<String> features;
  final double? rating;
  final double? latitude;
  final double? longitude;

  String get titleLabel => _fallback(title, 'Untitled trip');
  String get subtitleLabel => _fallback(subtitle, '');
  String get descriptionLabel => _fallback(description, '');
  String get fullDetailLabel => _fallback(fullDetail, '');
  String get categoryLabel => _fallback(category, 'Destination');
  String get durationLabel => _fallback(duration, '');

  bool get hasImage => imageUrl != null && imageUrl!.trim().isNotEmpty;
  bool get hasPrice => priceFrom != null;
  bool get hasRating => rating != null;
  bool get hasLocation => locationLabel.isNotEmpty;
  bool get hasCoordinate => latitude != null && longitude != null;
  bool get hasDescription => descriptionLabel.isNotEmpty;
  bool get hasFullDetail => fullDetailLabel.isNotEmpty;

  String get locationLabel {
    final parts = [city, province, country]
        .whereType<String>()
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return parts.join(', ');
  }

  String get priceLabel {
    if (priceFrom == null) return '';

    final amount = priceFrom! % 1 == 0
        ? priceFrom!.toStringAsFixed(0)
        : priceFrom!.toStringAsFixed(2);

    final currencyText = currency?.trim() ?? '';

    return currencyText.isEmpty ? amount : '$currencyText $amount';
  }

  String get ratingLabel {
    if (rating == null) return '';
    return rating!.toStringAsFixed(1);
  }

  String get coordinateLabel {
    if (!hasCoordinate) return '';
    return 'Lat: $latitude, Long: $longitude';
  }

  factory ResourceDetail.fromJson(Map<String, dynamic> json) {
    final imageUrl = _readString(json, 'imageUrl');

    return ResourceDetail(
      id: _readString(json, 'resourceId') ?? _readString(json, 'id'),
      slug: _readString(json, 'slug'),
      title: _readString(json, 'title'),
      subtitle: _readString(json, 'subtitle'),
      description: _readString(json, 'description'),
      fullDetail: _readString(json, 'fullDetail'),
      country: _readString(json, 'country'),
      province: _readString(json, 'province'),
      city: _readString(json, 'city'),
      category: _readString(json, 'category'),
      sourceType: _readString(json, 'sourceType'),
      priceFrom: _readDouble(json, 'priceFrom'),
      currency: _readString(json, 'currency'),
      duration: _readString(json, 'duration'),
      imageUrl: _cleanImageUrl(imageUrl),
      deepLink: _readString(json, 'deepLink'),
      tags: _readTextList(json['tags']),
      features: _readTextList(json['features']),
      rating: _readDouble(json, 'rating'),
      latitude: _readDouble(json, 'latitude'),
      longitude: _readDouble(json, 'longitude'),
    );
  }

  static String _fallback(String? value, String fallback) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  static String? _readString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;

    final text = value.toString().trim();
    if (text.isEmpty) return null;

    return text;
  }

  static double? _readDouble(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;

    if (value is num) return value.toDouble();

    return double.tryParse(value.toString());
  }

  static List<String> _readTextList(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return value
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return value
        .toString()
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static String? _cleanImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.trim().isEmpty) return null;

    if (imageUrl.contains('photo-1540521338287-41700207dee6')) {
      return null;
    }

    return imageUrl;
  }
}