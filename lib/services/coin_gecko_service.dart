import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vault/models/chart_data_model.dart';
import '../models/crypto_model.dart';

class CoinGeckoService {
  static const String baseUrl = 'https://api.coingecko.com/api/v3/';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),

      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<List<Crypto>> getTrendingCryptos() async {
    try {
      final response = await _dio.get(
        'coins/trending',
        queryParameters: {
          'vs_currency': 'usd',
          'order': 'market_cap_desc',
          'per_page': 20,
          'page': 1,
          'sparkline': false,
        },
      );

      // check response
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((json) => Crypto.fromJson(json)).toList();
      }
      throw Exception('Failed to load trending crypto');
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Fetching error: $e');
      rethrow;
    }
  }

  Future<List<Crypto>> getTop50Cryptos() async {
    try {
      final response = await _dio.get(
        'coins/markets',
        queryParameters: {
          'vs_currency': 'usd',
          'order': 'market_cap_desc',
          'per_page': 50,
          'page': 1,
          'sparkline': false,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((json) => Crypto.fromJson(json)).toList();
      }

      throw Exception('Failed to load cryptos');
    } on DioException catch (e) {
      debugPrint(' DioException: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint(' Error: $e');
      rethrow;
    }
  }

  Future<Crypto> getCryptoDetails(String cryptoId) async {
    try {
      final response = await _dio.get(
        'coins/$cryptoId',
        queryParameters: {'localization': false, 'market_data': true},
      );

      if (response.statusCode == 200) {
        return Crypto.fromJson(response.data);
      }
      throw Exception('Failed to load crypto details');
    } catch (e) {
      debugPrint(' Error: $e');
      rethrow;
    }
  }

  Future<List<ChartData>> getCryptoChartData(String cryptoId, int days) async {
    try {
      final response = await _dio.get(
        'coins/$cryptoId/ohlc',
        queryParameters: {'vs_currency': 'usd', 'days': days},
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((json) => ChartData.fromJson(json)).toList();
      }
      throw Exception('Failed to load chart data');
    } catch (e) {
      debugPrint(' Error: $e');
      rethrow;
    }
  }
}
