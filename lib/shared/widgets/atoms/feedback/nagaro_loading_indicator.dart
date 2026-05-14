import 'package:flutter/material.dart';
import 'package:nagaro/core/theme/theme.dart';

class NagaroLoadingIndicator extends StatelessWidget {
  const NagaroLoadingIndicator({
    super.key,
    this.size = 24.0,
    this.message,
  });

  final double size;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(strokeWidth: 2.5),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(message!, style: AppTextStyles.bodySmall),
          ],
        ],
      ),
    );
  }
}
