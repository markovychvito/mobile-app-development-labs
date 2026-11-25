import 'package:material_ui/material_ui.dart';
import 'package:my_project/theme/app_spacing.dart';

enum ButtonVariant { filled, outlined }

/// Кнопка на всю ширину з єдиним стилем для всього застосунку.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = ButtonVariant.filled,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon), const SizedBox(width: AppSpacing.s)],
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );

    return switch (variant) {
      ButtonVariant.filled => FilledButton(
        onPressed: onPressed,
        child: content,
      ),
      ButtonVariant.outlined => OutlinedButton(
        onPressed: onPressed,
        child: content,
      ),
    };
  }
}
