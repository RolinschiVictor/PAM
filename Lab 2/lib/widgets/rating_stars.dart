import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Row of 5 stars, filled up to [rating] (rounded down — matches the
/// filled-star look used throughout the design, no half stars).
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 14,
    this.color = AppColors.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final filled = rating.round();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < filled ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: color,
        );
      }),
    );
  }
}
