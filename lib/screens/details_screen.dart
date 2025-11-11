import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/constants/app_color.dart';
import 'package:vault/widgets/v_button.dart';
import '../models/crypto_model.dart';
import '../provider/chart_provider.dart';
import '../provider/crypto_provider.dart';
import '../widgets/v_line_chart.dart';

class DetailScreen extends StatefulWidget {
  final Crypto crypto;

  const DetailScreen({required this.crypto, super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final int _selectedDays = 30;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChartProvider>(
        context,
        listen: false,
      ).fetchChartData(widget.crypto.id, days: _selectedDays);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.crypto.symbol} - ${widget.crypto.name}'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        forceMaterialTransparency: true,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          Consumer<CryptoProvider>(
            builder: (context, provider, _) {
              return IconButton(
                icon: Icon(
                  widget.crypto.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color:
                      widget.crypto.isFavorite
                          ? AppColors.primary
                          : AppColors.white,
                ),
                onPressed: () {
                  provider.toggleFav(widget.crypto.id);
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.secondary,
              AppColors.primary.withAlpha(100),
              AppColors.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.gray.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            widget.crypto.image,
                            width: 50,
                            height: 50,
                            errorBuilder:
                                (_, __, ___) => const Icon(
                                  Icons.currency_bitcoin,
                                  size: 50,
                                ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${widget.crypto.currentPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                '${widget.crypto.priceChange24h.toStringAsFixed(2)}% (24h)',
                                style: TextStyle(
                                  color:
                                      widget.crypto.priceChange24h >= 0
                                          ? Colors.green
                                          : Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price Chart (30 days)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Consumer<ChartProvider>(
                      builder: (context, provider, _) {
                        if (provider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (provider.chartData.isEmpty) {
                          return const Center(
                            child: Text(
                              'No chart data available',
                              style: TextStyle(color: AppColors.white),
                            ),
                          );
                        }
                        return VLineChart(data: provider.chartData);
                      },
                    ),
                    const SizedBox(height: 32),

                    Text(
                      'Trading Statistics',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Market Cap',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          '\$${(widget.crypto.marketCap / 1e9).toStringAsFixed(2)}B',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: AppColors.white.withOpacity(0.2)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Market cap rank',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          '#${widget.crypto.marketCapRank}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: AppColors.white.withOpacity(0.2)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Open',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          '\$${widget.crypto.currentPrice}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),

                    //
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    VaultButton(
                      color: AppColors.error,
                      child: Text(
                        'Sell ${widget.crypto.symbol}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: VaultButton(
                        color: AppColors.success,
                        child: Center(
                          child: Text(
                            'Buy ${widget.crypto.symbol}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
