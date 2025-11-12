import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/provider/crypto_provider.dart';

import '../constants/app_color.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CryptoProvider>(
      builder: (context, provider, _) {
        final favorites = provider.favorites;
        return Scaffold(
          appBar: AppBar(title: const Text('Watchlist')),
          body: RefreshIndicator(
            onRefresh: () async {
              await provider.fetchCryptos(fromRefresh: true);
            },
            color: AppColors.white,
            backgroundColor: AppColors.primary,
            child: favorites.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 200),
                      Center(
                        child: Text(
                          'No favorites added yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemBuilder: (context, index) {
                      final crypto = favorites[index];
                      return Dismissible(
                        key: ValueKey(crypto.id),
                        background: Container(
                          color: AppColors.error,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: AppColors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => provider.toggleFav(crypto.id),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 8),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.white,
                            child: Image.network(
                              crypto.image,
                              errorBuilder: (_, __, ___) => const Icon(Icons.error),
                            ),
                          ),
                          title: Text(
                            crypto.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            crypto.symbol.toUpperCase(),
                            style: TextStyle(
                                color: AppColors.white.withAlpha(200),
                                fontSize: 14),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              crypto.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: crypto.isFavorite
                                  ? AppColors.primary
                                  : AppColors.white,
                            ),
                            onPressed: () => provider.toggleFav(crypto.id),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemCount: favorites.length,
                  ),
          ),
        );
      },
    );
  }
}
