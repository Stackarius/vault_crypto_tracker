import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vault/constants/app_color.dart';
import '../provider/crypto_provider.dart';

class VSearch extends StatelessWidget {
  const VSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (query) {
        Provider.of<CryptoProvider>(
          context,
          listen: false,
        ).searchCryptos(query);
      },

      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.white.withOpacity(0.5),
            width: 1,
          ),
        ),
        hintText: 'Search crypto...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColors.secondary,
      ),
    );
  }
}
