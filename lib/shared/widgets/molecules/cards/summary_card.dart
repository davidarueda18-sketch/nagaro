import 'package:flutter/material.dart';
import 'package:nagaro/core/theme/theme.dart';
import 'package:nagaro/shared/widgets/atoms/display/amount_text.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.label,
    required this.amount,
    this.polarity = AmountPolarity.neutral,
    this.sublabel,
    this.onTap,
  });

  final String label;
  final double amount;
  final AmountPolarity polarity;
  final String? sublabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgAll,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.sectionSubtitle),
              const SizedBox(height: AppSpacing.xs),
              AmountText(amount: amount, size: AmountSize.large, polarity: polarity),
              if (sublabel != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(sublabel!, style: AppTextStyles.caption),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
