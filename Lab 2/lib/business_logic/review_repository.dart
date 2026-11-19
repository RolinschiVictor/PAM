import '../models/review_model.dart';
import '../services/review_data_source.dart';

abstract interface class IReviewRepository {
  List<ReviewModel> getReviewsForProduct(String productId);
}

class ReviewRepository implements IReviewRepository {
  final ReviewDataSource _dataSource;

  ReviewRepository([ReviewDataSource? dataSource])
      : _dataSource = dataSource ?? ReviewDataSource();

  @override
  List<ReviewModel> getReviewsForProduct(String productId) {
    return _dataSource
        .fetchAllReviews()
        .where((r) => r.productId == productId)
        .toList();
  }
}
