import 'package:flutter/material.dart';
import 'package:vault/models/crypto_model.dart';

import '../constants/app_color.dart';

class VTile extends StatelessWidget {
  final Crypto crypto;
  final void Function()? ontap;

  const VTile({super.key, this.ontap, required this.crypto});

  @override
  Widget build(BuildContext context) {
    final isPositive = crypto.priceChange24h >= 0;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      onTap: ontap,
      textColor: AppColors.white,
      leading: ClipOval(
        clipBehavior: Clip.hardEdge,
        child: CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.white,
          child: Hero(
            tag: crypto.id,
            child: Image(
              image: NetworkImage(crypto.image),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
          ),
        ),
      ),
      title: Text(
        crypto.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        crypto.symbol.toUpperCase(),
        style: TextStyle(color: AppColors.white.withAlpha(200), fontSize: 14),
      ),
      trailing: SizedBox(
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\$${crypto.currentPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${crypto.priceChange24h}%',
              style: TextStyle(
                color: isPositive ? AppColors.success : AppColors.error,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
