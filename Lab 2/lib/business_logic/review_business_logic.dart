import '../models/review_model.dart';
import 'review_repository.dart';

class ReviewBusinessLogic {
  final IReviewRepository _repository;

  ReviewBusinessLogic({IReviewRepository? repository})
      : _repository = repository ?? ReviewRepository();

  List<ReviewModel> getReviewsForProduct(String productId) =>
      _repository.getReviewsForProduct(productId);

  /// Rating distribution (star -> %) lives on the product itself today,
  /// but is exposed here too so the UI never has to reach into the
  /// repository layer directly for anything review-related.
  Map<int, int> getRatingBreakdown(Map<int, int> productBreakdown) =>
      productBreakdown;
}
