import 'package:flutter/material.dart';
import 'package:vault/constants/app_color.dart';

class VaultButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final void Function()? ontap;
  const VaultButton({super.key, required this.child, this.color, this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
          color: color ?? AppColors.primary,
          border: Border.all(color: AppColors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        child: child,
      ),
    );
  }
}
