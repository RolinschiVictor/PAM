import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Fixed bottom bar with a shopping-bag icon and "Add To Cart" label.
class AddToCartBar extends StatelessWidget {
  final VoidCallback onPressed;

  const AddToCartBar({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonDark,
              foregroundColor: AppColors.buttonTextLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Add To Cart',
                  style: AppText.label.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
