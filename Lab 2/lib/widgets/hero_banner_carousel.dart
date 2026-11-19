import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Full-width rounded image banner ("Autumn Collection 2021") with a dot
/// page indicator. Built to take several banners even though the current
/// mock data only provides one, since the Figma design shows dots for 3.
class HeroBannerCarousel extends StatefulWidget {
  final List<String> imageAssets;
  final List<String> titles;

  const HeroBannerCarousel({
    super.key,
    required this.imageAssets,
    required this.titles,
  });

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.imageAssets.length;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.banner),
          child: SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _controller,
              itemCount: count,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(widget.imageAssets[i], fit: BoxFit.cover),
                    Positioned(
                      left: 24,
                      bottom: 28,
                      right: 24,
                      child: Text(
                        widget.titles[i],
                        style: AppText.bannerTitle.copyWith(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (i) {
            final active = i == _page;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? AppColors.selectedCategory : AppColors.divider,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
