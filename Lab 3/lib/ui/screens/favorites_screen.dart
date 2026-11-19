import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/favorites/favorites_cubit.dart';
import '../../logic/products/products_cubit.dart';
import '../../logic/products/products_state.dart';
import '../widgets/product_image.dart';
import '../widgets/state_views.dart';
import 'product_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite')),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, productsState) {
          return BlocBuilder<FavoritesCubit, Set<String>>(
            builder: (context, favoriteIds) {
              final items = productsState.all
                  .where((p) => favoriteIds.contains(p.id))
                  .toList();

              if (items.isEmpty) {
                return EmptyView(
                  title: 'Nicio piesă favorită',
                  message:
                      'Apasă pe inimioară la un produs ca să îl adaugi aici.',
                  buttonLabel: 'Înapoi la produse',
                  onPressed: () => Navigator.of(context).pop(),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = items[index];
                  final tag = 'fav-${p.id}';
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailsScreen(product: p, heroTag: tag),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 90,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Hero(
                              tag: tag,
                              child: ProductImage(url: p.imageUrl),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(p.formattedPrice),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Elimină din favorite',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () =>
                              context.read<FavoritesCubit>().remove(p.id),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
