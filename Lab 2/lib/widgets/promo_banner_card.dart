import 'package:flutter/material.dart';
import '../services/product_data_source.dart';
import '../theme/app_theme.dart';

/// Full-width promo card: light gray background, kicker + multi-line
/// title on the left, a circular cropped photo on the right. Reused for
/// "Hang Out & Party", "For Slim & Beauty" and "Most sexy & fabulous
/// design".
class PromoBannerCard extends StatelessWidget {
  final HomeBannerData data;
  final VoidCallback? onTap;
  final bool darkTitle;

  const PromoBannerCard({
    super.key,
    required this.data,
    this.onTap,
    this.darkTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.sectionBackground,
          borderRadius: BorderRadius.circular(AppRadii.banner),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (data.kicker.isNotEmpty) ...[
                    Row(
                      children: [
                        Container(width: 2, height: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            data.kicker,
                            style: AppText.bannerKicker,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],
                  Text(
                    data.title,
                    style: AppText.bannerTitle.copyWith(
                      color: darkTitle
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 110,
              height: 130,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE9E9EC),
                      shape: BoxShape.circle,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      data.imageAsset,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
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
