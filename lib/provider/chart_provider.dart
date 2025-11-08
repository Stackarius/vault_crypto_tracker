import 'package:flutter/material.dart';
import 'package:vault/services/coin_gecko_service.dart';
import 'package:vault/services/storage_service.dart';

import '../models/crypto_model.dart';

class CryptoProvider extends ChangeNotifier {
  final CoinGeckoService _coinGeckoService = CoinGeckoService();
  final StorageService _storageService = StorageService();

  List<Crypto> _allCryptos = [];
  List<Crypto> _filteredCryptos = [];
  List<String> _favorites = [];
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';

  List<Crypto> get favorites =>
      _allCryptos.where((c) => _favorites.contains(c.id)).toList();
  bool get isLoading => _isLoading;
  String get error => _error;

  //
  Future<void> fetchCryptos() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _allCryptos = await _coinGeckoService.getTo50Cryptos();
      await _storageService.saveCryptos(_allCryptos);

      _favorites = await _storageService.getFavorites();
      for (var crypto in _allCryptos) {
        crypto.isFavorite = _favorites.contains(crypto.id);
      }

      _filteredCryptos = _allCryptos;
      _isLoading = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;

      // try load from cache
      _allCryptos = await _storageService.getCacheedCryptos();
      _filteredCryptos = _allCryptos;
    }
    notifyListeners();
  }

  void searchCryptos(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _filteredCryptos = _allCryptos;
    } else {
      _filteredCryptos =
          _allCryptos
              .where(
                (crypto) =>
                    crypto.name.toLowerCase().contains(_searchQuery) ||
                    crypto.symbol.toLowerCase().contains(_searchQuery),
              )
              .toList();
    }
  }

  // toggle Favorite
  Future<void> toggleFav(String cryptoId) async {
    final isFav = _favorites.contains(cryptoId);

    if (!isFav) {
      _favorites.remove(cryptoId);
      await _storageService.removeFavorite(cryptoId);
    } else {
      _favorites.add(cryptoId);
      await _storageService.saveFavorite(cryptoId);
    }

    for (var crypto in _allCryptos) {
      if (crypto.id == cryptoId) {
        crypto.isFavorite = !isFav;
      }
    }
    notifyListeners();
  }
}
