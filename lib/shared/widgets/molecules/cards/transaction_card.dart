import 'package:flutter/material.dart';
import 'package:nagaro/core/theme/theme.dart';
import 'package:nagaro/shared/widgets/atoms/display/amount_text.dart';
import 'package:nagaro/shared/widgets/atoms/display/status_badge.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.polarity,
    required this.date,
    this.badge,
    this.badgeLabel,
    this.onTap,
    this.leadingIcon,
  });

  final String title;
  final String subtitle;
  final double amount;
  final AmountPolarity polarity;
  final String date;
  final BadgeVariant? badge;
  final String? badgeLabel;
  final VoidCallback? onTap;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgAll,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              _buildLeading(),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _buildContent()),
              const SizedBox(width: AppSpacing.sm),
              _buildTrailing(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.mdAll,
      ),
      child: Icon(
        leadingIcon ?? Icons.swap_horiz,
        size: 20,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyRegular,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(subtitle, style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _buildTrailing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AmountText(amount: amount, polarity: polarity, size: AmountSize.small, showSign: true),
        if (badge != null && badgeLabel != null) ...[
          const SizedBox(height: AppSpacing.xs),
          StatusBadge(label: badgeLabel!, variant: badge!),
        ] else ...[
          const SizedBox(height: AppSpacing.xs),
          Text(date, style: AppTextStyles.caption),
        ],
      ],
    );
  }
}
