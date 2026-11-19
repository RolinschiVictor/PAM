import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'rating_stars.dart';

/// "4.9 out of 5" big number + stars on the left, 5-row percentage bar
/// chart on the right — matches the Reviews section of the Product Page.
class RatingBreakdown extends StatelessWidget {
  final double average;
  final int count;
  final Map<int, int> breakdown; // star -> percent

  const RatingBreakdown({
    super.key,
    required this.average,
    required this.count,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              average.toStringAsFixed(1),
              style: AppText.productPageTitle.copyWith(fontSize: 30),
            ),
            Text('OUT OF 5', style: AppText.body.copyWith(fontSize: 10)),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RatingStars(rating: average, size: 16),
                  Text('$count ratings', style: AppText.body.copyWith(fontSize: 11)),
                ],
              ),
              const SizedBox(height: 10),
              for (final star in [5, 4, 3, 2, 1])
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: _BarRow(star: star, percent: breakdown[star] ?? 0),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BarRow extends StatelessWidget {
  final int star;
  final int percent;

  const _BarRow({required this.star, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$star', style: AppText.body.copyWith(fontSize: 11)),
        const Icon(Icons.star_rounded, size: 12, color: AppColors.selectedCategory),
        const SizedBox(width: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 5,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation(AppColors.accentTeal),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 30,
          child: Text('$percent%', style: AppText.body.copyWith(fontSize: 11)),
        ),
      ],
    );
  }
}
