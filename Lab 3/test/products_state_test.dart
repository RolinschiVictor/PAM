import 'package:flutter_test/flutter_test.dart';
import 'package:gemstore_lab3/data/models/product.dart';
import 'package:gemstore_lab3/logic/products/products_state.dart';

void main() {
  const items = [
    Product(id: '1', name: 'Zebra Hoodie', price: 50, currency: 'USD', imageUrl: '', collection: 'A'),
    Product(id: '2', name: 'Alpha Shirt', price: 20, currency: 'USD', imageUrl: '', collection: 'B'),
    Product(id: '3', name: 'Mid Dress', price: 35, currency: 'USD', imageUrl: '', collection: 'A'),
  ];

  const base = ProductsState(status: ProductsStatus.success, all: items);

  test('cautare dupa nume', () {
    expect(base.copyWith(query: 'dress').visible.map((p) => p.id), ['3']);
  });

  test('filtrare dupa colectie si pret', () {
    final s = base.copyWith(collection: 'A', priceLimit: 40);
    expect(s.visible.map((p) => p.id), ['3']);
  });

  test('sortare dupa pret', () {
    expect(base.copyWith(sort: SortOption.priceAsc).visible.map((p) => p.id), ['2', '3', '1']);
    expect(base.copyWith(sort: SortOption.priceDesc).visible.map((p) => p.id), ['1', '3', '2']);
  });

  test('sortare alfabetica', () {
    expect(base.copyWith(sort: SortOption.nameAsc).visible.map((p) => p.id), ['2', '3', '1']);
  });
}
