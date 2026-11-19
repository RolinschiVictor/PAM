import 'dart:ui' show Color;

import 'package:equatable/equatable.dart';

class ColorOption extends Equatable {
  final String id;
  final String name;
  final String hex;

  const ColorOption({required this.id, required this.name, required this.hex});

  factory ColorOption.fromJson(Map<String, dynamic> json) => ColorOption(
        id: json['id'] as String,
        name: json['name'] as String,
        hex: json['value'] as String,
      );

  Color get color =>
      Color(int.parse(hex.replaceFirst('#', ''), radix: 16) + 0xFF000000);

  @override
  List<Object?> get props => [id, name, hex];
}

class Review extends Equatable {
  final String id;
  final String author;
  final String avatarUrl;
  final double rating;
  final String createdAtLabel;
  final String text;

  const Review({
    required this.id,
    required this.author,
    required this.avatarUrl,
    required this.rating,
    required this.createdAtLabel,
    required this.text,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'] as String,
        author: json['author'] as String,
        avatarUrl: json['avatarUrl'] as String,
        rating: (json['rating'] as num).toDouble(),
        createdAtLabel: json['createdAtLabel'] as String,
        text: json['text'] as String,
      );

  @override
  List<Object?> get props => [id];
}

class RatingStat extends Equatable {
  final int stars;
  final int percentage;

  const RatingStat({required this.stars, required this.percentage});

  factory RatingStat.fromJson(Map<String, dynamic> json) => RatingStat(
        stars: json['stars'] as int,
        percentage: (json['percentage'] as num).toInt(),
      );

  @override
  List<Object?> get props => [stars, percentage];
}

/// Produs. Campurile de detaliu sunt optionale: doar unele produse din JSON
/// au pagina de detalii completa (ex. p003).
class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String imageUrl;

  /// Sectiunea din JSON din care provine produsul (folosita la filtrare).
  final String collection;

  final String description;
  final double rating;
  final int ratingCount;
  final int reviewCount;
  final List<String> gallery;
  final List<ColorOption> colors;
  final String? selectedColorId;
  final List<String> sizes;
  final String? selectedSize;
  final Map<String, bool> sizeAvailability;
  final List<RatingStat> ratingBreakdown;
  final List<Review> reviews;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.imageUrl,
    required this.collection,
    this.description = 'Fără descriere disponibilă pentru acest produs.',
    this.rating = 0,
    this.ratingCount = 0,
    this.reviewCount = 0,
    this.gallery = const [],
    this.colors = const [],
    this.selectedColorId,
    this.sizes = const [],
    this.selectedSize,
    this.sizeAvailability = const {},
    this.ratingBreakdown = const [],
    this.reviews = const [],
  });

  /// Produs "scurt" (featureProducts / recommended / similarProducts).
  factory Product.fromJson(Map<String, dynamic> json,
      {required String collection}) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      imageUrl: json['imageUrl'] as String,
      collection: collection,
    );
  }

  /// Produs cu toate detaliile (productPage.product).
  factory Product.fromDetailsJson(Map<String, dynamic> json,
      {required String collection}) {
    final gallery = (json['galleryImageUrls'] as List? ?? const [])
        .map((e) => e as String)
        .toList();
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      imageUrl: json['mainImageUrl'] as String,
      collection: collection,
      description: json['description'] as String? ??
          'Fără descriere disponibilă pentru acest produs.',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      gallery: gallery,
      colors: (json['availableColors'] as List? ?? const [])
          .map((e) => ColorOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedColorId: json['selectedColor'] as String?,
      sizes: (json['availableSizes'] as List? ?? const [])
          .map((e) => e as String)
          .toList(),
      selectedSize: json['selectedSize'] as String?,
      sizeAvailability:
          (json['sizeAvailability'] as Map<String, dynamic>? ?? const {})
              .map((k, v) => MapEntry(k, v as bool)),
      ratingBreakdown: (json['ratingBreakdown'] as List? ?? const [])
          .map((e) => RatingStat.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: (json['reviews'] as List? ?? const [])
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String get formattedPrice =>
      '${currency == 'USD' ? '\$' : '$currency '}${price.toStringAsFixed(2)}';

  @override
  List<Object?> get props => [id];
}
