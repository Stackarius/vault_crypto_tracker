import 'package:hive_flutter/hive_flutter.dart';

import '../models/crypto_model.dart';

class StorageService {
  static const String cryptoBoxName = 'cryptos';
  static const String favoriteBoxName = 'crypto_favorite';

  // Save Crypto
  Future<void> saveCryptos(List<Crypto> cryptos) async {
    final box = await Hive.openBox(cryptoBoxName);
    await box.clear();
    for (var crypto in cryptos) {
      await box.put(crypto.id, crypto.toJson());
    }
  }

  Future<List<Crypto>> getCacheedCryptos() async {
    final box = await Hive.openBox(cryptoBoxName);
    final List<Crypto> cryptos = [];
    for (var key in box.keys) {
      final json = box.get(key) as Map<dynamic, dynamic>;
      cryptos.add(Crypto.fromJson(Map<String, dynamic>.from(json)));
    }
    return cryptos;
  }

  Future<void> saveFavorite(String cryptoId) async {
    final box = await Hive.openBox(favoriteBoxName);
    await box.put(cryptoId, true);
  }

  Future<void> removeFavorite(String cryptoId) async {
    final box = await Hive.openBox(favoriteBoxName);
    await box.delete(cryptoId);
  }

  Future<List<String>> getFavorites() async {
    final box = await Hive.openBox(favoriteBoxName);
    return box.keys.cast<String>().toList();
  }

  Future<bool> isFavorite(String cryptoId) async {
    final box = await Hive.openBox(favoriteBoxName);
    return box.containsKey(cryptoId);
  }
}
