import 'package:flutter/material.dart';

import '../../data/models/product.dart';
import '../screens/product_details_screen.dart';
import 'favorite_button.dart';
import 'product_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  /// Prefix unic per ecran, ca sa nu existe doua Hero cu acelasi tag.
  final String heroPrefix;

  const ProductCard({
    super.key,
    required this.product,
    required this.heroPrefix,
  });

  @override
  Widget build(BuildContext context) {
    final tag = '$heroPrefix-${product.id}';
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product, heroTag: tag),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Hero(
                      tag: tag,
                      child: ProductImage(url: product.imageUrl),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: FavoriteButton(productId: product.id),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                product.formattedPrice,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (product.rating > 0) ...[
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 2),
                Text(product.rating.toString(),
                    style: const TextStyle(fontSize: 12)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
