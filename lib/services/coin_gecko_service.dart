import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vault/models/chart_data_model.dart';

import '../models/crypto_model.dart';

class CoinGeckoService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://api.coingecko.com/api/v3';

  //
  Future<List<Crypto>> getTo50Cryptos() async {
    try {
      final response = await _dio.get(
        '$baseUrl/coins/markets',
        queryParameters: {
          'vs_currency': 'ngn',
          'order': 'market_cap_desc',
          'per_page': 50,
          'page': 1,
          'sparkline': false,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Crypto.fromJson(json)).toList();
      }

      throw Exception('failsed to load cryptos');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Crypto> getCryptoDetails(String cryptoId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/coins/$cryptoId',
        queryParameters: {'localization': false, 'market_data': true},
      );

      if (response.statusCode == 200) {
        return Crypto.fromJson(response.data);
      }
      throw Exception('Failed to load crypto details');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<ChartData>> getCryptoChartData(String cryptoId, int days) async {
    try {
      final response = await _dio.get(
        '$baseUrl/coins/$cryptoId/ohlc',
        queryParameters: {'vs_currency': 'usd', 'days': days},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ChartData.fromJson(json)).toList();
      }
      throw Exception('Failed to load chart data');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
