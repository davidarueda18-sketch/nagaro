import 'package:flutter/material.dart';

class NagaroGhostButton extends StatelessWidget {
  const NagaroGhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 16) : const SizedBox.shrink(),
      label: Text(label),
    );
  }
}
