import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme.dart';
import 'data/repositories/store_repository.dart';
import 'logic/cart/cart_cubit.dart';
import 'logic/favorites/favorites_cubit.dart';
import 'logic/products/products_cubit.dart';
import 'ui/screens/home_screen.dart';

class GemStoreApp extends StatelessWidget {
  const GemStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => StoreRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) =>
                ProductsCubit(ctx.read<StoreRepository>())..load(),
          ),
          BlocProvider(create: (_) => FavoritesCubit()),
          BlocProvider(create: (_) => CartCubit()),
        ],
        child: MaterialApp(
          title: 'GemStore',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
