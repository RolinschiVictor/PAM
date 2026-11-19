import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/services.dart' show rootBundle;

import '../models/store_data.dart';

class StoreException implements Exception {
  final String message;
  const StoreException(this.message);

  @override
  String toString() => message;
}

/// Moduri de incarcare - utile pentru a demonstra toate starile aplicatiei.
enum LoadMode { normal, simulateError, simulateEmpty }

class StoreRepository {
  static const String assetPath = 'assets/data/store.json';

  /// Incarca asincron datele din fisierul JSON din assets.
  Future<StoreData> loadStore({LoadMode mode = LoadMode.normal}) async {
    // Simulam latenta de retea pentru a vedea starea Loading.
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mode == LoadMode.simulateError) {
      throw const StoreException(
          'Nu s-au putut încărca datele (eroare simulată).');
    }
    if (mode == LoadMode.simulateEmpty) {
      return const StoreData.empty();
    }

    try {
      final raw = await rootBundle.loadString(assetPath);
      // Parsarea JSON ruleaza intr-un Isolate separat.
      return await compute(parseStoreData, raw);
    } catch (e) {
      throw StoreException('Fișier JSON invalid sau lipsă: $e');
    }
  }
}
