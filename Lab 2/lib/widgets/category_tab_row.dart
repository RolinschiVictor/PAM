import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/product_data_source.dart';
import '../theme/app_theme.dart';

/// Women / Men / Accessories / Beauty selector row from the Home Page.
class CategoryTabRow extends StatelessWidget {
  final String selectedId;
  final ValueChanged<String> onSelected;

  const CategoryTabRow({
    super.key,
    required this.selectedId,
    required this.onSelected,
  });

  static const List<CategoryModel> categories = [
    CategoryModel(id: 'women', label: 'Women', icon: CategoryIcons.women),
    CategoryModel(id: 'men', label: 'Men', icon: CategoryIcons.men),
    CategoryModel(
        id: 'accessories',
        label: 'Accessories',
        icon: CategoryIcons.accessories),
    CategoryModel(id: 'beauty', label: 'Beauty', icon: CategoryIcons.beauty),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((c) => _CategoryItem(
            category: c,
            selected: c.id == selectedId,
            onTap: () => onSelected(c.id),
          )).toList(),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected
                  ? AppColors.selectedCategory
                  : AppColors.unselectedCategoryBg,
            ),
            child: Icon(
              category.icon,
              color: selected ? Colors.white : AppColors.textMuted,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.label,
            style: selected
                ? AppText.categoryLabelSelected
                : AppText.categoryLabelUnselected,
          ),
        ],
      ),
    );
  }
}
