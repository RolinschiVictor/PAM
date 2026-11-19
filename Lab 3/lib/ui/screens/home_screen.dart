import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/store_data.dart';
import '../../data/repositories/store_repository.dart';
import '../../logic/cart/cart_cubit.dart';
import '../../logic/favorites/favorites_cubit.dart';
import '../../logic/products/products_cubit.dart';
import '../../logic/products/products_state.dart';
import '../../data/models/cart_item.dart';
import '../widgets/filter_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/product_image.dart';
import '../widgets/search_field.dart';
import '../widgets/state_views.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCubit, ProductsState>(
      // Dupa prima incarcare cu succes, preluam favoritele din JSON.
      listenWhen: (prev, curr) =>
          prev.status != curr.status && curr.status == ProductsStatus.success,
      listener: (context, state) =>
          context.read<FavoritesCubit>().seed(state.initialFavorites),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<ProductsCubit, ProductsState>(
            buildWhen: (p, c) => p.storeName != c.storeName,
            builder: (context, state) => Text(state.storeName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          actions: [
            BlocBuilder<CartCubit, List<CartItem>>(
              builder: (context, cartItems) {
                final totalCount =
                    cartItems.fold(0, (sum, item) => sum + item.quantity);
                return IconButton(
                  tooltip: 'Coș de cumpărături',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  ),
                  icon: Badge(
                    isLabelVisible: totalCount > 0,
                    label: Text('$totalCount'),
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                );
              },
            ),
            BlocBuilder<FavoritesCubit, Set<String>>(
              builder: (context, favs) => IconButton(
                tooltip: 'Favorite',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                ),
                icon: Badge(
                  isLabelVisible: favs.isNotEmpty,
                  label: Text('${favs.length}'),
                  child: const Icon(Icons.favorite_border),
                ),
              ),
            ),
            PopupMenuButton<LoadMode>(
              tooltip: 'Demo stări',
              onSelected: (mode) =>
                  context.read<ProductsCubit>().load(mode: mode),
              itemBuilder: (_) => const [
                PopupMenuItem(
                    value: LoadMode.normal, child: Text('Reîncarcă date')),
                PopupMenuItem(
                    value: LoadMode.simulateError,
                    child: Text('Simulează eroare')),
                PopupMenuItem(
                    value: LoadMode.simulateEmpty,
                    child: Text('Simulează listă goală')),
              ],
            ),
          ],
        ),
        body: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            final cubit = context.read<ProductsCubit>();
            switch (state.status) {
              case ProductsStatus.loading:
                return const LoadingView();
              case ProductsStatus.error:
                return ErrorView(
                  message: state.errorMessage ?? 'Eroare necunoscută.',
                  onRetry: () => cubit.load(),
                );
              case ProductsStatus.empty:
                return EmptyView(
                  title: 'Nu există produse',
                  message: 'Fișierul JSON nu conține niciun produs.',
                  buttonLabel: 'Reîncarcă',
                  onPressed: () => cubit.load(),
                );
              case ProductsStatus.success:
                return _SuccessBody(state: state);
            }
          },
        ),
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  final ProductsState state;

  const _SuccessBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();
    final products = state.visible;

    return RefreshIndicator(
      onRefresh: () => cubit.load(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (state.hero != null)
            SliverToBoxAdapter(child: _HeroBanner(hero: state.hero!)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  SearchField(query: state.query, onChanged: cubit.setQuery),
                  const SizedBox(height: 8),
                  FilterBar(state: state),
                ],
              ),
            ),
          ),
          if (products.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyView(
                title: 'Niciun rezultat',
                message:
                    'Nu am găsit produse care să corespundă căutării sau filtrelor.',
                buttonLabel: 'Resetează filtrele',
                onPressed: cubit.resetFilters,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.66,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ProductCard(
                      product: products[index], heroPrefix: 'home'),
                  childCount: products.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final HeroBanner hero;

  const _HeroBanner({required this.hero});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ProductImage(url: hero.imageUrl),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black54, Colors.transparent],
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hero.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (hero.action.isNotEmpty)
                  Text(hero.action,
                      style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
