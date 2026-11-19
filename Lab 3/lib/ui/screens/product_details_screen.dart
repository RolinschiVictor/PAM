import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product.dart';
import '../../logic/cart/cart_cubit.dart';
import '../../logic/favorites/favorites_cubit.dart';
import '../../logic/products/products_cubit.dart';
import '../widgets/favorite_button.dart';
import '../widgets/product_card.dart';
import '../widgets/product_image.dart';
import '../widgets/rating_stars.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final String heroTag;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.heroTag,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Stare locala de UI (nu apartine logicii de business).
  String? _colorId;
  String? _size;
  bool _expanded = false;
  int _page = 0;

  Product get p => widget.product;

  @override
  void initState() {
    super.initState();
    _colorId = p.selectedColorId;
    _size = p.selectedSize;
  }

  @override
  Widget build(BuildContext context) {
    final gallery = p.gallery.isEmpty ? [p.imageUrl] : p.gallery;
    final similar = context
        .read<ProductsCubit>()
        .state
        .all
        .where((o) => o.id != p.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FavoriteButton(productId: p.id),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 380,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: gallery.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) {
                    final image = ProductImage(url: gallery[i]);
                    return i == 0
                        ? Hero(tag: widget.heroTag, child: image)
                        : image;
                  },
                ),
                if (gallery.length > 1)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        gallery.length,
                        (i) => Container(
                          width: i == _page ? 18 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: i == _page ? Colors.white : Colors.white54,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(p.name,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                    Text(p.formattedPrice,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                if (p.rating > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RatingStars(rating: p.rating),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text('${p.rating} (${p.ratingCount} evaluări, '
                            '${p.reviewCount} recenzii)'),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                _title('Descriere'),
                Text(
                  p.description,
                  maxLines: _expanded ? null : 3,
                  overflow:
                      _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      _expanded ? 'Mai puțin' : 'Citește mai mult',
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                if (p.colors.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _title('Culoare'),
                  Wrap(
                    spacing: 12,
                    children: [
                      for (final c in p.colors)
                        GestureDetector(
                          onTap: () => setState(() => _colorId = c.id),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: c.color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _colorId == c.id
                                    ? Colors.red
                                    : Colors.black12,
                                width: _colorId == c.id ? 3 : 1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
                if (p.sizes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _title('Mărime'),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (final s in p.sizes)
                        ChoiceChip(
                          label: Text(s),
                          selected: _size == s,
                          onSelected: (p.sizeAvailability[s] ?? true)
                              ? (_) => setState(() => _size = s)
                              : null,
                        ),
                    ],
                  ),
                ],
                if (p.ratingBreakdown.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _title('Evaluări'),
                  for (final r in p.ratingBreakdown)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          SizedBox(width: 32, child: Text('${r.stars} ★')),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: r.percentage / 100,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(
                            width: 44,
                            child: Text('${r.percentage}%',
                                textAlign: TextAlign.end),
                          ),
                        ],
                      ),
                    ),
                ],
                if (p.reviews.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _title('Recenzii'),
                  for (final r in p.reviews)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFF2F2F4),
                        backgroundImage: NetworkImage(r.avatarUrl),
                        onBackgroundImageError: (_, __) {},
                      ),
                      title: Row(
                        children: [
                          Expanded(child: Text(r.author)),
                          Text(r.createdAtLabel,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black45)),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingStars(rating: r.rating, size: 14),
                          const SizedBox(height: 4),
                          Text(r.text),
                        ],
                      ),
                    ),
                ],
                if (similar.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _title('Alte produse'),
                  SizedBox(
                    height: 230,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: similar.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => SizedBox(
                        width: 140,
                        child: ProductCard(
                            product: similar[i], heroPrefix: 'sim-${p.id}'),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              BlocBuilder<FavoritesCubit, Set<String>>(
                builder: (context, favs) {
                  final isFav = favs.contains(p.id);
                  return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(54, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () =>
                        context.read<FavoritesCubit>().toggle(p.id),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : null,
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _addToCart,
                  child: const Text('Add To Cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );

  void _addToCart() {
    final colorObj = p.colors.where((c) => c.id == _colorId).firstOrNull;
    final colorName = colorObj?.name;

    context.read<CartCubit>().addItem(
          p,
          size: _size,
          color: colorName,
        );

    final options = [
      if (colorName != null) 'Culoare: $colorName',
      if (_size != null) 'Mărime: $_size',
    ].where((e) => e.isNotEmpty).join(', ');

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
            '${p.name}${options.isEmpty ? '' : ' ($options)'} a fost adăugat în coș.'),
        action: SnackBarAction(
          label: 'Vezi coșul',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CartScreen()),
          ),
        ),
      ));
  }
}
