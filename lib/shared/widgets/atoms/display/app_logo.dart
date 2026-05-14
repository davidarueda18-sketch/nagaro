import 'package:flutter/material.dart';
import 'package:nagaro/core/theme/theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 40.0,
    this.showLabel = false,
  });

  final double size;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final circle = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        'N',
        style: TextStyle(
          color: AppColors.surface,
          fontSize: size * 0.45,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (!showLabel) return circle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        circle,
        const SizedBox(width: AppSpacing.sm),
        const Text('Nagaro', style: AppTextStyles.sectionTitle),
      ],
    );
  }
}
