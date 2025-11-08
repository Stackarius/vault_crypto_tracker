import 'package:flutter/material.dart';

class Crypto {
  final String id;
  final String name;
  final String symbol;
  final double currentPrice;
  final double priceChange24h;
  final String image;
  final double marketCap;
  final int marketCapRank;
  bool isFavorite;

  Crypto({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.priceChange24h,
    required this.image,
    required this.marketCap,
    required this.marketCapRank,
    this.isFavorite = false,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol']?.toString().toUpperCase() ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChange24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      marketCapRank: json['market_cap_rank'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'current_price': currentPrice,
      'price_change_percentage_24h': priceChange24h,
      'image': image,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'isFavorite': isFavorite,
    };
  }

  Crypto copyWith({
    String? id,
    String? name,
    String? symbol,
    double? currentPrice,
    double? priceChange24h,
    String? image,
    double? marketCap,
    int? marketCapRank,
    bool? isFavorite,
  }) {
    return Crypto(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      currentPrice: currentPrice ?? this.currentPrice,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      image: image ?? this.image,
      marketCap: marketCap ?? this.marketCap,
      marketCapRank: marketCapRank ?? this.marketCapRank,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
