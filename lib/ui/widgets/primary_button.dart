import 'package:material_ui/material_ui.dart';
import 'package:my_project/ui/theme/app_spacing.dart';

enum ButtonVariant { filled, outlined }

/// Кнопка на всю ширину з єдиним стилем для всього застосунку.
/// Поки [isLoading] = true, показує спінер і блокує повторні натискання.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = ButtonVariant.filled,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final content = isLoading
        ? const SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon),
                const SizedBox(width: AppSpacing.s),
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          );
    final callback = isLoading ? null : onPressed;

    return switch (variant) {
      ButtonVariant.filled => FilledButton(onPressed: callback, child: content),
      ButtonVariant.outlined => OutlinedButton(
        onPressed: callback,
        child: content,
      ),
    };
  }
}
