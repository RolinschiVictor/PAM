import '../models/product_model.dart';
import '../services/product_data_source.dart';

/// Contract the business-logic layer depends on.
///
/// This is the Dart equivalent of the `IProduct` interface in the prompt's
/// conceptual example: the UI/business-logic layers only ever know about
/// this abstract contract, never about [ProductDataSource] directly. That
/// means the mock implementation below can later be swapped for a
/// `RemoteProductRepository` (backed by `http`/a database) without
/// changing a single widget.
abstract interface class IProductRepository {
  List<ProductModel> getFeaturedProducts();
  List<ProductModel> getRecommendedProducts();
  List<ProductModel> getSimilarProducts(String excludingProductId);
  ProductModel? getProductById(String id);
}

/// Concrete implementation backed by the local mock [ProductDataSource].
/// Equivalent to `class Product : UserApi, IProduct` in the prompt,
/// expressed with composition (idiomatic in Dart) instead of inheritance.
class ProductRepository implements IProductRepository {
  final ProductDataSource _dataSource;

  ProductRepository([ProductDataSource? dataSource])
      : _dataSource = dataSource ?? ProductDataSource();

  @override
  List<ProductModel> getFeaturedProducts() {
    final all = _dataSource.fetchAllProducts();
    return all.take(3).toList();
  }

  @override
  List<ProductModel> getRecommendedProducts() {
    final all = _dataSource.fetchAllProducts();
    return all.skip(3).take(2).toList();
  }

  @override
  List<ProductModel> getSimilarProducts(String excludingProductId) {
    final all = _dataSource.fetchAllProducts();
    return all.skip(5).where((p) => p.id != excludingProductId).toList();
  }

  @override
  ProductModel? getProductById(String id) {
    final all = _dataSource.fetchAllProducts();
    for (final product in all) {
      if (product.id == id) return product;
    }
    return null;
  }
}
