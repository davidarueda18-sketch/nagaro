import 'package:flutter/material.dart';
import 'package:nagaro/core/theme/theme.dart';
import 'package:nagaro/shared/widgets/atoms/display/amount_text.dart';

class GoalProgressCard extends StatelessWidget {
  const GoalProgressCard({
    super.key,
    required this.name,
    required this.currentAmount,
    required this.targetAmount,
    required this.progress,
    this.deadline,
    this.onTap,
  });

  final String name;
  final double currentAmount;
  final double targetAmount;
  final double progress;
  final String? deadline;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgAll,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: AppTextStyles.sectionTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (deadline != null)
                    Text(deadline!, style: AppTextStyles.caption),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AmountText(amount: currentAmount),
                  AmountText(amount: targetAmount, size: AmountSize.small),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: AppRadius.fullAll,
                child: LinearProgressIndicator(
                  value: clampedProgress,
                  minHeight: 6,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    clampedProgress >= 1.0 ? AppColors.success : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${(clampedProgress * 100).toStringAsFixed(0)}% completado',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
