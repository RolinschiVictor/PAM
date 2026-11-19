import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// "Feature Products   Show all" style header, reused above every
/// horizontal product list and the Top Collection section.
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onShowAll;

  const SectionHeader({super.key, required this.title, this.onShowAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppText.sectionHeading),
        GestureDetector(
          onTap: onShowAll,
          child: Text('Show all', style: AppText.showAll),
        ),
      ],
    );
  }
}
