import 'package:equatable/equatable.dart';
import 'product.dart';

class CartItem extends Equatable {
  final Product product;
  final String? size;
  final String? color;
  final int quantity;

  const CartItem({
    required this.product,
    this.size,
    this.color,
    this.quantity = 1,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      size: size,
      color: color,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => product.price * quantity;

  String get formattedTotalPrice {
    final currency = product.currency == 'USD' ? '\$' : '${product.currency} ';
    return '$currency${totalPrice.toStringAsFixed(2)}';
  }

  @override
  List<Object?> get props => [product.id, size, color, quantity];
}
