import '../models/review_model.dart';

/// Lowest layer for review data — same role as [ProductDataSource], kept
/// as a separate class because reviews are a separate concern/entity.
class ReviewDataSource {
  List<ReviewModel> fetchAllReviews() {
    return const [
      ReviewModel(
        id: 'r1',
        productId: 'p3',
        authorName: 'Jennifer Rose',
        avatarImage: 'assets/images/avatar_jennifer.png',
        stars: 5,
        comment:
            "I love it. Awesome customer service! Helped me out with "
            "adding an additional item to my order. Thanks again!",
        postedAgo: '5m ago',
      ),
      ReviewModel(
        id: 'r2',
        productId: 'p3',
        authorName: 'Kelly Rihana',
        avatarImage: 'assets/images/avatar_kelly.png',
        stars: 5,
        comment:
            "I'm very happy with order, It was delivered on and good "
            "quality. Recommended!",
        postedAgo: '9m ago',
      ),
    ];
  }
}
