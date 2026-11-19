import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Two side-by-side rounded photo cards with a small category label and
/// bold caption, used for the closing "T-Shirts / Dresses" row.
class TwoColumnBanner extends StatelessWidget {
  final String leftImage;
  final String leftLabel;
  final String leftCaption;
  final String rightImage;
  final String rightLabel;
  final String rightCaption;
  final ValueChanged<bool>? onTap; // true = left tapped

  const TwoColumnBanner({
    super.key,
    required this.leftImage,
    required this.leftLabel,
    required this.leftCaption,
    required this.rightImage,
    required this.rightLabel,
    required this.rightCaption,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Tile(
            image: leftImage,
            label: leftLabel,
            caption: leftCaption,
            onTap: () => onTap?.call(true),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _Tile(
            image: rightImage,
            label: rightLabel,
            caption: rightCaption,
            onTap: () => onTap?.call(false),
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final String image;
  final String label;
  final String caption;
  final VoidCallback onTap;

  const _Tile({
    required this.image,
    required this.label,
    required this.caption,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.banner),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 0.73,
              child: Image.asset(image, fit: BoxFit.cover),
            ),
            Positioned(
              left: 14,
              top: 18,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppText.bannerKicker),
                  const SizedBox(height: 6),
                  Text(
                    caption,
                    style: AppText.bannerTitle.copyWith(fontSize: 19),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
