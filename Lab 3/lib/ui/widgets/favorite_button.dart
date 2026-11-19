import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/favorites/favorites_cubit.dart';

class FavoriteButton extends StatelessWidget {
  final String productId;
  final double size;

  const FavoriteButton({super.key, required this.productId, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, Set<String>>(
      builder: (context, favorites) {
        final isFav = favorites.contains(productId);
        return Material(
          color: Colors.white,
          elevation: 1,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.read<FavoritesCubit>().toggle(productId),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                size: size,
                color: isFav ? Colors.red : Colors.black54,
              ),
            ),
          ),
        );
      },
    );
  }
}
