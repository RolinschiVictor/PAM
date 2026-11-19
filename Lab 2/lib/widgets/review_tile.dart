import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../theme/app_theme.dart';
import 'rating_stars.dart';

class ReviewTile extends StatelessWidget {
  final ReviewModel review;

  const ReviewTile({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, backgroundImage: AssetImage(review.avatarImage)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(review.authorName, style: AppText.label.copyWith(fontSize: 14)),
                    Text(review.postedAgo, style: AppText.body.copyWith(fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 4),
                RatingStars(rating: review.stars.toDouble(), size: 13),
                const SizedBox(height: 6),
                Text(review.comment, style: AppText.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
