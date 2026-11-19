import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/store_repository.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final StoreRepository _repository;

  ProductsCubit(this._repository) : super(const ProductsState());

  /// Incarcare asincrona: Loading -> Success / Empty / Error.
  Future<void> load({LoadMode mode = LoadMode.normal}) async {
    emit(const ProductsState(status: ProductsStatus.loading));
    try {
      final data = await _repository.loadStore(mode: mode);
      if (data.products.isEmpty) {
        emit(ProductsState(
          status: ProductsStatus.empty,
          storeName: data.storeName,
        ));
        return;
      }
      emit(ProductsState(
        status: ProductsStatus.success,
        storeName: data.storeName,
        hero: data.hero,
        all: data.products,
        initialFavorites: data.initialFavorites,
      ));
    } catch (e) {
      emit(ProductsState(
        status: ProductsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void setQuery(String query) => emit(state.copyWith(query: query));

  void setCollection(String? collection) => emit(
        collection == null
            ? state.copyWith(clearCollection: true)
            : state.copyWith(collection: collection),
      );

  void setPriceLimit(double? limit) => emit(
        limit == null
            ? state.copyWith(clearPriceLimit: true)
            : state.copyWith(priceLimit: limit),
      );

  void setSort(SortOption sort) => emit(state.copyWith(sort: sort));

  void resetFilters() => emit(state.copyWith(
        query: '',
        clearCollection: true,
        clearPriceLimit: true,
        sort: SortOption.none,
      ));
}
