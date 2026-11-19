import 'package:flutter_test/flutter_test.dart';
import 'package:gemstore_lab3/data/models/product.dart';
import 'package:gemstore_lab3/logic/cart/cart_cubit.dart';

void main() {
  group('CartCubit Tests', () {
    test('Initial state is empty', () {
      final cubit = CartCubit();
      expect(cubit.state, isEmpty);
      expect(cubit.totalItems, 0);
      expect(cubit.totalAmount, 0.0);
    });

    test('Add item to cart increases count and total', () {
      final cubit = CartCubit();
      const product = Product(
        id: 'p1',
        name: 'Test Product',
        price: 100.0,
        currency: 'USD',
        imageUrl: '',
        collection: 'test',
      );

      cubit.addItem(product, size: 'M', color: 'Red', quantity: 2);

      expect(cubit.state.length, 1);
      expect(cubit.totalItems, 2);
      expect(cubit.totalAmount, 200.0);
      expect(cubit.state.first.size, 'M');
      expect(cubit.state.first.color, 'Red');
    });
  });
}
