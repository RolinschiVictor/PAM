import 'package:flutter/material.dart';
import '../models/product_model.dart';

/// Lowest layer of the stack (UI -> Business Logic -> Data/Service).
///
/// This plays the role of `UserApi` in the conceptual example: it is the
/// only place that knows *where* product data actually comes from. Today
/// it returns hand-written mock data; later this class's body can be
/// swapped for real `http` / database calls without touching anything
/// above it (repositories, business logic, UI all stay the same).
class ProductDataSource {
  List<ProductModel> fetchAllProducts() {
    return const [
      ProductModel(
        id: 'p1',
        name: 'Turtleneck Sweater',
        category: 'Women',
        price: 39.99,
        description:
            'A soft, fitted turtleneck sweater that layers perfectly under '
            'blazers or on its own with tailored trousers.',
        images: ['assets/images/product_turtleneck.png'],
      ),
      ProductModel(
        id: 'p2',
        name: 'Long Sleeve Dress',
        category: 'Women',
        price: 45.00,
        description:
            'A flowing long sleeve midi dress in a printed pattern, finished '
            'with a tie waist for a flattering silhouette.',
        images: ['assets/images/product_longsleeve_dress.png'],
      ),
      ProductModel(
        id: 'p3',
        name: 'Sportwear Set',
        category: 'Women',
        price: 80.00,
        description:
            'Sportswear is no longer under culture, it is no longer indie '
            'or cobbled together as it once was. Sport is fashion today. '
            'The top is oversized in fit and style, may need to size down.',
        images: [
          'assets/images/product_sportswear_hero.png',
          'assets/images/product_sportswear_hero.png',
          'assets/images/product_sportswear_hero.png',
        ],
        colors: [
          ProductColorOption(name: 'Tan', colorValue: 0xFFE3C2A6),
          ProductColorOption(name: 'Black', colorValue: 0xFF1D1B20),
          ProductColorOption(name: 'Red', colorValue: 0xFFE06A6A),
        ],
        sizes: ['S', 'M', 'L'],
        ratingAverage: 4.9,
        ratingCount: 83,
        ratingBreakdown: {5: 80, 4: 12, 3: 5, 2: 3, 1: 0},
        totalReviewCount: 47,
      ),
      ProductModel(
        id: 'p4',
        name: 'White fashion hoodie',
        category: 'Women',
        price: 29.00,
        description:
            'A relaxed cropped hoodie with contrast stripe detailing on the '
            'sleeves, great for off-duty days.',
        images: ['assets/images/product_hoodie.png'],
      ),
      ProductModel(
        id: 'p5',
        name: 'Cotton T-Shirt',
        category: 'Women',
        price: 30.00,
        description:
            'An essential cotton tee with a printed front graphic, cut for '
            'an easy, everyday fit.',
        images: ['assets/images/product_cotton_tee.png'],
      ),
      ProductModel(
        id: 'p6',
        name: 'Rise Crop Hoodie',
        category: 'Women',
        price: 43.00,
        description: 'A cropped hoodie designed for high-waist bottoms.',
        images: ['assets/images/product_rise_crop_hoodie.png'],
      ),
      ProductModel(
        id: 'p7',
        name: 'Gym Crop Top',
        category: 'Women',
        price: 39.99,
        description: 'Breathable cropped top built for low-impact training.',
        images: ['assets/images/product_gym_crop_top.png'],
      ),
      ProductModel(
        id: 'p8',
        name: 'Sport Sweatshirt',
        category: 'Women',
        price: 47.99,
        description: 'A heavyweight sweatshirt with a relaxed, sporty cut.',
        images: ['assets/images/product_hoodie.png'],
      ),
    ];
  }
}

/// Static content for the promo banners on the Home Page. These aren't
/// "products", so they get their own tiny data source rather than being
/// bolted onto [ProductModel].
class HomeBannerData {
  final String imageAsset;
  final String kicker;
  final String title;
  const HomeBannerData({
    required this.imageAsset,
    required this.kicker,
    required this.title,
  });
}

class BannerDataSource {
  List<HomeBannerData> fetchHeroBanners() => const [
        HomeBannerData(
          imageAsset: 'assets/images/banner_autumn.png',
          kicker: '',
          title: 'Autumn Collection 2021',
        ),
      ];

  HomeBannerData fetchHangoutBanner() => const HomeBannerData(
        imageAsset: 'assets/images/banner_hangout.png',
        kicker: 'NEW COLLECTION',
        title: 'HANG OUT\n& PARTY',
      );

  HomeBannerData fetchSlimBeautyBanner() => const HomeBannerData(
        imageAsset: 'assets/images/banner_slim_beauty.png',
        kicker: 'Sale up to 40%',
        title: 'FOR SLIM\n& BEAUTY',
      );

  HomeBannerData fetchSummerBanner() => const HomeBannerData(
        imageAsset: 'assets/images/banner_summer.png',
        kicker: 'Summer Collection 2021',
        title: 'Most sexy\n& fabulous\ndesign',
      );
}

/// Category icons/labels for the Women/Men/Accessories/Beauty row.
class CategoryIcons {
  static const women = Icons.female_rounded;
  static const men = Icons.male_rounded;
  static const accessories = Icons.visibility_outlined;
  static const beauty = Icons.spa_outlined;
}
