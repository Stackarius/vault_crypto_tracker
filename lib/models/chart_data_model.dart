class ChartData {
  final DateTime timestamp;
  final double open;
  final double high;
  final double low;
  final double close;

  ChartData({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory ChartData.fromJson(List<dynamic> json) {
    return ChartData(
      timestamp: DateTime.fromMillisecondsSinceEpoch(json[0].toInt()),
      open: (json[1] ?? 0).toDouble(),
      high: (json[2] ?? 0).toDouble(),
      low: (json[3] ?? 0).toDouble(),
      close: (json[4] ?? 0).toDouble(),
    );
  }
}
