import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/constants/app_color.dart';
import 'package:vault/provider/crypto_provider.dart';
import 'package:vault/widgets/v_button.dart';
import 'package:vault/widgets/v_search.dart';
import 'package:vault/widgets/v_tile.dart';

import 'details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CryptoProvider>(
      builder: (context, provider, _) {
        return RefreshIndicator(
          semanticsLabel: 'Pull to refresh',
          semanticsValue: 'Refreshing content',
          notificationPredicate: (notification) => true,
          color: AppColors.white,
          backgroundColor: AppColors.primary,
          strokeWidth: 3,
          displacement: 80,
          onRefresh: () async {
            await provider.fetchTrending(fromRefresh: true);
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(color: AppColors.black),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile row
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                child: Image.asset('assets/images/Shape1.png'),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Hi there,",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.white,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.settings_outlined,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Balance section
                          const Text(
                            "Total Balance",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "\$25,590.00",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Buttons row
                          Row(
                            children: [
                              Expanded(
                                child: VaultButton(
                                  child: Center(
                                    child: const Text(
                                      'Deposit',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                  ontap: () {},
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: VaultButton(
                                  color: AppColors.secondary,
                                  child: Center(
                                    child: const Text(
                                      'Withdraw',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                  ontap: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Second SliverAppBar for trending and search
              SliverAppBar(
                pinned: true,
                floating: false,
                toolbarHeight: 120,
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.black,

                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Trending',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              children: const [
                                Text(
                                  'See All',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const VSearch(),
                    ],
                  ),
                ),
              ),

              // --- Crypto List Section ---
              if (provider.isLoading && provider.allCryptos.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.error.isNotEmpty && provider.allCryptos.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'Error: ${provider.error}',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final crypto = provider.filteredCrypto[index];
                      return VTile(
                        crypto: crypto,
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DetailScreen(crypto: crypto);
                              },
                            ),
                          );
                        },
                      );
                    }, childCount: provider.filteredCrypto.length),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
