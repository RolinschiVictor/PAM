import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';

/// Vertical card used in the "Feature Products" horizontal list: tall
/// rounded photo, name, price underneath.
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final double width;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.width = 148,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.card),
              child: AspectRatio(
                aspectRatio: 0.73,
                child: Image.asset(product.thumbnail, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10),
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
    );
  }
}
