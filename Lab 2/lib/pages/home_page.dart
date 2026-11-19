import 'package:flutter/material.dart';
import '../business_logic/product_business_logic.dart';
import '../models/product_model.dart';
import '../services/product_data_source.dart';
import '../theme/app_theme.dart';
import '../widgets/category_tab_row.dart';
import '../widgets/hero_banner_carousel.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner_card.dart';
import '../widgets/section_header.dart';
import '../widgets/small_product_tile.dart';
import '../widgets/two_column_banner.dart';
import 'product_page.dart';

/// Home Page — reproduces the Figma "GemStore" home screen:
/// app bar, category row, hero banner, Feature Products, Hang Out & Party
/// banner, Recommended, Top Collection, two promo banners, and the
/// closing T-Shirts/Dresses row.
///
/// The page itself stays "dumb": it only asks [ProductBusinessLogic] for
/// data and hands it to widgets. No business rules live here.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductBusinessLogic _productBL = ProductBusinessLogic();
  final BannerDataSource _banners = BannerDataSource();

  String _selectedCategory = 'women';

  void _openProduct(ProductModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductPage(productId: product.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final featured = _productBL.getFeaturedProducts();
    final recommended = _productBL.getRecommendedProducts();
    final hangout = _banners.fetchHangoutBanner();
    final slimBeauty = _banners.fetchSlimBeautyBanner();
    final summer = _banners.fetchSummerBanner();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const HomeAppBar(),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ).copyWith(bottom: 32),
          children: [
            CategoryTabRow(
              selectedId: _selectedCategory,
              onSelected: (id) => setState(() => _selectedCategory = id),
            ),
            const SizedBox(height: 22),
            HeroBannerCarousel(
              imageAssets: const [
                'assets/images/banner_autumn.png',
                'assets/images/banner_autumn.png',
                'assets/images/banner_autumn.png',
              ],
              titles: const [
                'Autumn Collection 2021',
                'Autumn Collection 2021',
                'Autumn Collection 2021',
              ],
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            SectionHeader(title: 'Feature Products', onShowAll: () {}),
            const SizedBox(height: 16),
            SizedBox(
              height: 256,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featured.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, i) => ProductCard(
                  product: featured[i],
                  onTap: () => _openProduct(featured[i]),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            PromoBannerCard(data: hangout, onTap: () {}),
            const SizedBox(height: AppSpacing.sectionGap),
            SectionHeader(title: 'Recommended', onShowAll: () {}),
            const SizedBox(height: 16),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recommended.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, i) => SmallProductTile(
                  product: recommended[i],
                  onTap: () => _openProduct(recommended[i]),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            SectionHeader(title: 'Top Collection', onShowAll: () {}),
            const SizedBox(height: 16),
            PromoBannerCard(data: slimBeauty, onTap: () {}, darkTitle: false),
            const SizedBox(height: 16),
            PromoBannerCard(data: summer, onTap: () {}),
            const SizedBox(height: 16),
            TwoColumnBanner(
              leftImage: 'assets/images/banner_tshirts.png',
              leftLabel: 'T-Shirts',
              leftCaption: 'The\nOffice\nLife',
              rightImage: 'assets/images/banner_dresses.png',
              rightLabel: 'Dresses',
              rightCaption: 'Elegant\nDesign',
              onTap: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
