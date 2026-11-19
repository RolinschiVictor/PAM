import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'product.dart';

class CategoryItem extends Equatable {
  final String id;
  final String name;
  final bool selected;

  const CategoryItem(
      {required this.id, required this.name, required this.selected});

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
        id: json['id'] as String,
        name: json['name'] as String,
        selected: json['selected'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [id, name, selected];
}

class HeroBanner extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final String action;

  const HeroBanner({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.action,
  });

  factory HeroBanner.fromJson(Map<String, dynamic> json) => HeroBanner(
        id: json['id'] as String,
        title: json['title'] as String,
        imageUrl: json['imageUrl'] as String,
        action: json['action'] as String? ?? '',
      );

  @override
  List<Object?> get props => [id];
}

class StoreData extends Equatable {
  final String storeName;
  final List<CategoryItem> categories;
  final HeroBanner? hero;
  final List<Product> products;
  final Set<String> initialFavorites;

  const StoreData({
    required this.storeName,
    required this.categories,
    required this.hero,
    required this.products,
    required this.initialFavorites,
  });

  const StoreData.empty()
      : storeName = 'GemStore',
        categories = const [],
        hero = null,
        products = const [],
        initialFavorites = const {};

  @override
  List<Object?> get props => [storeName, products, initialFavorites];
}

/// Functie top-level: poate fi rulata intr-un Isolate prin `compute`.
StoreData parseStoreData(String rawJson) {
  final root = jsonDecode(rawJson) as Map<String, dynamic>;
  final home = root['homePage'] as Map<String, dynamic>;
  final productPage = root['productPage'] as Map<String, dynamic>?;

  // Ordine: featured -> recommended -> similar. Cheie = id (fara duplicate).
  final byId = <String, Product>{};

  void addAll(List? list, String collection) {
    for (final e in list ?? const []) {
      final p =
          Product.fromJson(e as Map<String, dynamic>, collection: collection);
      byId.putIfAbsent(p.id, () => p);
    }
  }

  addAll(home['featureProducts'] as List?, 'Featured');
  addAll(home['recommended'] as List?, 'Recommended');

  final favorites = <String>{};
  final detailsJson = productPage?['product'] as Map<String, dynamic>?;
  if (detailsJson != null) {
    addAll(detailsJson['similarProducts'] as List?, 'Similar');
    final id = detailsJson['id'] as String;
    final collection = byId[id]?.collection ?? 'Featured';
    byId[id] = Product.fromDetailsJson(detailsJson, collection: collection);
    final actions = detailsJson['actions'] as Map<String, dynamic>?;
    if (actions?['isFavorite'] == true) favorites.add(id);
  }

  final heroJson = home['heroBanner'] as Map<String, dynamic>?;

  return StoreData(
    storeName: home['storeName'] as String? ?? 'GemStore',
    categories: (home['categories'] as List? ?? const [])
        .map((e) => CategoryItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    hero: heroJson == null ? null : HeroBanner.fromJson(heroJson),
    products: byId.values.toList(),
    initialFavorites: favorites,
  );
}
