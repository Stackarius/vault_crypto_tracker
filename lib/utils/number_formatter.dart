String formatMarketCap(double value) {
  if (value >= 1000000000000) {
    return '\$${(value / 1000000000000).toStringAsFixed(2)}T';
  } else if (value >= 1000000000) {
    return '\$${(value / 1000000000).toStringAsFixed(2)}B';
  } else if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(2)}M';
  } else if (value >= 1000) {
    return '\$${(value / 1000).toStringAsFixed(2)}K';
  } else {
    return '\$${value.toStringAsFixed(2)}';
  }
}
