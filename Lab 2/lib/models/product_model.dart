/// Data model for a single product.
///
/// Mirrors what the Figma design actually shows (name, image, price,
/// description, category, rating...) plus the extra fields the Product
/// Page needs (gallery, colors, sizes). Keep this model backend-agnostic:
/// today it is populated from [MockProductDataSource], tomorrow it can be
/// populated from a REST/GraphQL response without any UI changes.
class ProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;

  /// First image is used as the card/list thumbnail. All images together
  /// are used for the gallery carousel on the Product Page.
  final List<String> images;

  final List<ProductColorOption> colors;
  final List<String> sizes;

  final double ratingAverage;
  final int ratingCount;

  /// Distribution of ratings, star -> percentage (0-100). Keys 5..1.
  final Map<int, int> ratingBreakdown;

  /// Total written-review count shown next to "Write a review" — kept
  /// separate from [ratingCount] (the star-rating count) since the design
  /// shows two different numbers ("83 ratings" vs "47 Reviews").
  final int totalReviewCount;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.images,
    this.colors = const [],
    this.sizes = const [],
    this.ratingAverage = 0,
    this.ratingCount = 0,
    this.ratingBreakdown = const {},
    this.totalReviewCount = 0,
  });

  String get thumbnail => images.first;

  String get formattedPrice => '\$ ${price.toStringAsFixed(2)}';
}

class ProductColorOption {
  final String name;
  final int colorValue; // ARGB int, kept primitive so the model has no Flutter import.

  const ProductColorOption({required this.name, required this.colorValue});
}
