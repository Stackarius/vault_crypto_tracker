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

  List<Crypto> get allCryptos => _allCryptos;
  List<Crypto> get filteredCrypto => _filteredCryptos;
  List<Crypto> get favorites =>
      _allCryptos.where((c) => _favorites.contains(c.id)).toList();
  bool get isLoading => _isLoading;
  String get error => _error;

  // fetch trending cryptos
  Future<void> fetchTrending({bool fromRefresh = false}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final newData = await _coinGeckoService.getTrendingCryptos();
      await _storageService.saveCryptos(newData);
      _allCryptos = newData;

      _favorites = await _storageService.getFavorites();
      for (var crypto in _allCryptos) {
        crypto.isFavorite = _favorites.contains(crypto.id);
      }

      _filteredCryptos = _allCryptos;
      _isLoading = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;

      // Load from cache
      final cachedData = await _storageService.getCacheedCryptos();

      // Only use cached data if e dey
      if (cachedData.isNotEmpty) {
        _allCryptos = cachedData;
        _filteredCryptos = cachedData;

        if (fromRefresh) {
          _error = 'Offline mode: Showing cached data';
        }
      }
    }
  }

  // fetch 50 cryptos
  Future<void> fetchCryptos({bool fromRefresh = false}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final newData = await _coinGeckoService.getTop50Cryptos();
      await _storageService.saveCryptos(newData);
      _allCryptos = newData;

      _favorites = await _storageService.getFavorites();
      for (var crypto in _allCryptos) {
        crypto.isFavorite = _favorites.contains(crypto.id);
      }

      _filteredCryptos = _allCryptos;
      _isLoading = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;

      // Load from cache
      final cachedData = await _storageService.getCacheedCryptos();

      if (cachedData.isNotEmpty) {
        _allCryptos = cachedData;
        _filteredCryptos = cachedData;

        if (fromRefresh) {
          _error = 'Offline mode: Showing cached data';
        }
      }
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

    if (isFav) {
      _favorites.remove(cryptoId);
      await _storageService.removeFavorite(cryptoId);
      print('Removed from favorites: $cryptoId');
    } else {
      _favorites.add(cryptoId);
      await _storageService.saveFavorite(cryptoId);
      print('Added to favorites: $cryptoId');
    }

    for (var crypto in _allCryptos) {
      if (crypto.id == cryptoId) {
        crypto.isFavorite = !isFav;
        break;
      }
    }
    notifyListeners();
  }
}
