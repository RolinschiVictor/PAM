/// A single customer review shown on the Product Page.
class ReviewModel {
  final String id;
  final String productId;
  final String authorName;
  final String avatarImage;
  final int stars; // 1-5
  final String comment;
  final String postedAgo; // e.g. "5m ago" — pre-formatted for simplicity.

  const ReviewModel({
    required this.id,
    required this.productId,
    required this.authorName,
    required this.avatarImage,
    required this.stars,
    required this.comment,
    required this.postedAgo,
  });
}
