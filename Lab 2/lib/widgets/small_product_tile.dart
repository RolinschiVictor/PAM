import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';

/// Horizontal tile used in the "Recommended" row: square thumbnail on the
/// left, name + price on the right, inside a soft rounded card.
class SmallProductTile extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const SmallProductTile({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 210,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.sectionBackground,
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                product.thumbnail,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.productName,
                  ),
                  const SizedBox(height: 4),
                  Text(product.formattedPrice, style: AppText.productPrice),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
