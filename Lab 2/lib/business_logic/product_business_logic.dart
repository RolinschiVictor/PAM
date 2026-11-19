import '../models/product_model.dart';
import 'product_repository.dart';

/// This is the layer pages/widgets actually talk to — equivalent to
/// `BussinesLogic` in the prompt's conceptual example. It never touches
/// [ProductDataSource] itself; it only knows the [IProductRepository]
/// contract, so UI code never has to change if the data source changes.
///
/// UI  ->  ProductBusinessLogic  ->  IProductRepository  ->  ProductDataSource
class ProductBusinessLogic {
  final IProductRepository _repository;

  ProductBusinessLogic({IProductRepository? repository})
      : _repository = repository ?? ProductRepository();

  List<ProductModel> getFeaturedProducts() =>
      _repository.getFeaturedProducts();

  List<ProductModel> getRecommendedProducts() =>
      _repository.getRecommendedProducts();

  List<ProductModel> getSimilarProducts(String currentProductId) =>
      _repository.getSimilarProducts(currentProductId);

  ProductModel? getProductById(String id) => _repository.getProductById(id);
}
