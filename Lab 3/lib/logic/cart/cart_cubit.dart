import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super(const []);

  void addItem(Product product, {String? size, String? color, int quantity = 1}) {
    final currentList = List<CartItem>.from(state);

    final index = currentList.indexWhere(
      (item) => item.product.id == product.id && item.size == size && item.color == color,
    );

    if (index >= 0) {
      final existing = currentList[index];
      currentList[index] = existing.copyWith(quantity: existing.quantity + quantity);
    } else {
      currentList.add(CartItem(
        product: product,
        size: size,
        color: color,
        quantity: quantity,
      ));
    }

    emit(currentList);
  }

  void updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(item);
      return;
    }
    final currentList = List<CartItem>.from(state);
    final index = currentList.indexWhere(
      (i) => i.product.id == item.product.id && i.size == item.size && i.color == item.color,
    );
    if (index >= 0) {
      currentList[index] = item.copyWith(quantity: newQuantity);
      emit(currentList);
    }
  }

  void removeItem(CartItem item) {
    final currentList = List<CartItem>.from(state);
    currentList.removeWhere(
      (i) => i.product.id == item.product.id && i.size == item.size && i.color == item.color,
    );
    emit(currentList);
  }

  void clear() {
    emit([]);
  }

  double get totalAmount => state.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
}
