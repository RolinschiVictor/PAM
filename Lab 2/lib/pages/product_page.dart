import 'package:flutter/material.dart';
import '../business_logic/product_business_logic.dart';
import '../business_logic/review_business_logic.dart';
import '../models/product_model.dart';
import '../models/review_model.dart';
import '../theme/app_theme.dart';
import '../widgets/add_to_cart_bar.dart';
import '../widgets/color_swatch_selector.dart';
import '../widgets/expandable_section.dart';
import '../widgets/product_card.dart';
import '../widgets/product_gallery.dart';
import '../widgets/rating_breakdown.dart';
import '../widgets/rating_stars.dart';
import '../widgets/review_tile.dart';
import '../widgets/size_selector.dart';

/// Product Page — receives a [productId], looks the product up through
/// [ProductBusinessLogic] and renders it exactly as shown in the Figma
/// design: gallery, price/rating header, color & size pickers,
/// description, reviews with a rating breakdown, similar products, and a
/// fixed Add To Cart bar.
class ProductPage extends StatefulWidget {
  final String productId;

  const ProductPage({super.key, required this.productId});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductBusinessLogic _productBL = ProductBusinessLogic();
  final ReviewBusinessLogic _reviewBL = ReviewBusinessLogic();

  int _selectedColor = 0;
  int _selectedSize = 0;
  bool _isFavorite = false;
  bool _didInitSize = false;

  @override
  Widget build(BuildContext context) {
    final product = _productBL.getProductById(widget.productId);

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Product not found')),
      );
    }

    // Default the size selection to the last size (matches the Figma
    // design, where "L" starts selected) the first time we see sizes.
    if (!_didInitSize && product.sizes.length > 1) {
      _didInitSize = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedSize = product.sizes.length - 1);
      });
    }

    final reviews = _reviewBL.getReviewsForProduct(product.id);
    final similar = _productBL.getSimilarProducts(product.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ProductGallery(
                  images: product.images,
                  onBack: () => Navigator.of(context).maybePop(),
                  isFavorite: _isFavorite,
                  onToggleFavorite: () =>
                      setState(() => _isFavorite = !_isFavorite),
                ),
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppRadii.sheet),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Header(product: product),
                        const SizedBox(height: 18),
                        const Divider(color: AppColors.divider, height: 1),
                        const SizedBox(height: 18),
                        if (product.colors.isNotEmpty || product.sizes.isNotEmpty)
                          _ColorAndSizeRow(
                            product: product,
                            selectedColor: _selectedColor,
                            selectedSize: _selectedSize,
                            onColorSelected: (i) =>
                                setState(() => _selectedColor = i),
                            onSizeSelected: (i) =>
                                setState(() => _selectedSize = i),
                          ),
                        const SizedBox(height: 22),
                        ExpandableSection(
                          title: 'Description',
                          child: _Description(text: product.description),
                        ),
                        if (product.ratingCount > 0) ...[
                          const SizedBox(height: 26),
                          ExpandableSection(
                            title: 'Reviews',
                            child: _ReviewsBlock(
                              product: product,
                              reviews: reviews,
                            ),
                          ),
                        ],
                        if (similar.isNotEmpty) ...[
                          const SizedBox(height: 26),
                          ExpandableSection(
                            title: 'Similar Product',
                            child: SizedBox(
                              height: 236,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: similar.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 14),
                                itemBuilder: (context, i) => ProductCard(
                                  width: 130,
                                  product: similar[i],
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => ProductPage(
                                          productId: similar[i].id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AddToCartBar(onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${product.name} added to cart')),
            );
          }),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final ProductModel product;

  const _Header({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: AppText.productPageTitle),
              if (product.ratingCount > 0) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    RatingStars(rating: product.ratingAverage, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '(${product.ratingCount})',
                      style: AppText.body.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Text(product.formattedPrice, style: AppText.productPagePrice),
      ],
    );
  }
}

class _ColorAndSizeRow extends StatelessWidget {
  final ProductModel product;
  final int selectedColor;
  final int selectedSize;
  final ValueChanged<int> onColorSelected;
  final ValueChanged<int> onSizeSelected;

  const _ColorAndSizeRow({
    required this.product,
    required this.selectedColor,
    required this.selectedSize,
    required this.onColorSelected,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.colors.isNotEmpty)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Color', style: AppText.label),
                const SizedBox(height: 10),
                ColorSwatchSelector(
                  options: product.colors,
                  selectedIndex: selectedColor,
                  onSelected: onColorSelected,
                ),
              ],
            ),
          ),
        if (product.sizes.isNotEmpty)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Size', style: AppText.label),
                const SizedBox(height: 10),
                SizeSelector(
                  sizes: product.sizes,
                  selectedIndex: selectedSize,
                  onSelected: onSizeSelected,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Description extends StatelessWidget {
  final String text;

  const _Description({required this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: AppText.body,
        children: [
          TextSpan(text: text),
          TextSpan(
            text: '  Read more',
            style: AppText.body.copyWith(
              color: AppColors.accentTeal,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsBlock extends StatelessWidget {
  final ProductModel product;
  final List<ReviewModel> reviews;

  const _ReviewsBlock({required this.product, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingBreakdown(
          average: product.ratingAverage,
          count: product.ratingCount,
          breakdown: product.ratingBreakdown,
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${product.totalReviewCount} Reviews',
                style: AppText.body.copyWith(fontSize: 12)),
            Row(
              children: [
                Text(
                  'WRITE A REVIEW',
                  style: AppText.body.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.edit_outlined, size: 14),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),
        for (final r in reviews) ReviewTile(review: r),
      ],
    );
  }
}
