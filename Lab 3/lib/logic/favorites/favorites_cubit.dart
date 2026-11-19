import 'package:flutter_bloc/flutter_bloc.dart';

/// Starea = multimea id-urilor produselor favorite.
class FavoritesCubit extends Cubit<Set<String>> {
  FavoritesCubit() : super(const {});

  bool _seeded = false;

  /// Preia favoritele initiale din JSON (o singura data).
  void seed(Set<String> ids) {
    if (_seeded) return;
    _seeded = true;
    emit({...state, ...ids});
  }

  void toggle(String id) {
    final next = {...state};
    if (!next.remove(id)) next.add(id);
    emit(next);
  }

  void remove(String id) => emit({...state}..remove(id));
}
