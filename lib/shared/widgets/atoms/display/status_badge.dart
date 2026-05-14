import 'package:flutter/material.dart';
import 'package:nagaro/core/theme/theme.dart';

enum BadgeVariant { success, warning, error, info, neutral }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.neutral,
  });

  final String label;
  final BadgeVariant variant;

  Color _baseColor() => switch (variant) {
        BadgeVariant.success => AppColors.success,
        BadgeVariant.warning => AppColors.warning,
        BadgeVariant.error   => AppColors.error,
        BadgeVariant.info    => AppColors.secondary,
        BadgeVariant.neutral => AppColors.textSecondary,
      };

  @override
  Widget build(BuildContext context) {
    final base = _baseColor();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: base.withValues(alpha: 0.12),
        borderRadius: AppRadius.fullAll,
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: base,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
