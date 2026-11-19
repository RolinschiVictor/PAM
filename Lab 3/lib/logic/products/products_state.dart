import 'package:equatable/equatable.dart';

import '../../data/models/product.dart';
import '../../data/models/store_data.dart';

enum ProductsStatus { loading, success, empty, error }

enum SortOption {
  none('Implicit'),
  nameAsc('Nume (A-Z)'),
  priceAsc('Preț crescător'),
  priceDesc('Preț descrescător');

  final String label;
  const SortOption(this.label);
}

class ProductsState extends Equatable {
  final ProductsStatus status;
  final String storeName;
  final HeroBanner? hero;
  final List<Product> all;
  final Set<String> initialFavorites;
  final String query;
  final String? collection; // null = toate
  final double? priceLimit; // null = fara limita
  final SortOption sort;
  final String? errorMessage;

  const ProductsState({
    this.status = ProductsStatus.loading,
    this.storeName = 'GemStore',
    this.hero,
    this.all = const [],
    this.initialFavorites = const {},
    this.query = '',
    this.collection,
    this.priceLimit,
    this.sort = SortOption.none,
    this.errorMessage,
  });

  /// Lista afisata: cautare + filtrare + sortare aplicate peste `all`.
  List<Product> get visible {
    final q = query.trim().toLowerCase();
    final list = all.where((p) {
      final matchQuery = q.isEmpty || p.name.toLowerCase().contains(q);
      final matchCollection = collection == null || p.collection == collection;
      final matchPrice = priceLimit == null || p.price <= priceLimit!;
      return matchQuery && matchCollection && matchPrice;
    }).toList();

    switch (sort) {
      case SortOption.nameAsc:
        list.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case SortOption.priceAsc:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.none:
        break;
    }
    return list;
  }

  List<String> get collections =>
      all.map((p) => p.collection).toSet().toList();

  double get priceCeiling {
    if (all.isEmpty) return 1;
    final max = all.map((p) => p.price).reduce((a, b) => a > b ? a : b);
    return max.ceilToDouble();
  }

  bool get hasActiveFilters =>
      query.trim().isNotEmpty || collection != null || priceLimit != null;

  ProductsState copyWith({
    ProductsStatus? status,
    String? storeName,
    HeroBanner? hero,
    List<Product>? all,
    Set<String>? initialFavorites,
    String? query,
    String? collection,
    bool clearCollection = false,
    double? priceLimit,
    bool clearPriceLimit = false,
    SortOption? sort,
    String? errorMessage,
  }) {
    return ProductsState(
      status: status ?? this.status,
      storeName: storeName ?? this.storeName,
      hero: hero ?? this.hero,
      all: all ?? this.all,
      initialFavorites: initialFavorites ?? this.initialFavorites,
      query: query ?? this.query,
      collection: clearCollection ? null : (collection ?? this.collection),
      priceLimit: clearPriceLimit ? null : (priceLimit ?? this.priceLimit),
      sort: sort ?? this.sort,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        storeName,
        hero,
        all,
        initialFavorites,
        query,
        collection,
        priceLimit,
        sort,
        errorMessage,
      ];
}
