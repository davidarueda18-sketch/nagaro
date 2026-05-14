import 'package:flutter/material.dart';
import 'package:nagaro/core/theme/theme.dart';
import 'package:nagaro/core/utils/currency_formatter.dart';

enum AmountPolarity { neutral, income, expense }

enum AmountSize { large, medium, small }

class AmountText extends StatelessWidget {
  const AmountText({
    super.key,
    required this.amount,
    this.size = AmountSize.medium,
    this.polarity = AmountPolarity.neutral,
    this.showSign = false,
    this.compact = false,
  });

  final double amount;
  final AmountSize size;
  final AmountPolarity polarity;
  final bool showSign;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = switch (polarity) {
      AmountPolarity.income  => AppColors.income,
      AmountPolarity.expense => AppColors.expense,
      AmountPolarity.neutral => AppColors.textPrimary,
    };

    final baseStyle = switch (size) {
      AmountSize.large  => AppTextStyles.amountLarge,
      AmountSize.medium => AppTextStyles.amountMedium,
      AmountSize.small  => AppTextStyles.amountSmall,
    };

    final prefix = switch (showSign) {
      true when polarity == AmountPolarity.income  => '+',
      true when polarity == AmountPolarity.expense => '-',
      _ => '',
    };

    final formatted = compact
        ? CurrencyFormatter.formatCompact(amount)
        : CurrencyFormatter.format(amount);

    return Text(
      '$prefix$formatted',
      style: baseStyle.copyWith(color: color),
    );
  }
}
