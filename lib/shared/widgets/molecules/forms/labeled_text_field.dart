import 'package:flutter/material.dart';
import 'package:nagaro/core/theme/theme.dart';
import 'package:nagaro/shared/widgets/atoms/inputs/nagaro_text_field.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.errorText,
    this.helperText,
    this.isRequired = false,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final bool isRequired;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabelRow(label: label, isRequired: isRequired),
        const SizedBox(height: AppSpacing.xs),
        NagaroTextField(
          controller: controller,
          hint: hint,
          errorText: errorText,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          enabled: enabled,
        ),
        if (helperText != null && errorText == null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(helperText!, style: AppTextStyles.caption),
        ],
      ],
    );
  }
}

class _LabelRow extends StatelessWidget {
  const _LabelRow({required this.label, required this.isRequired});

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    if (!isRequired) return Text(label, style: AppTextStyles.bodySmall);
    return Row(
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        const SizedBox(width: 2),
        const Text('*', style: TextStyle(color: AppColors.error, fontSize: 12)),
      ],
    );
  }
}
