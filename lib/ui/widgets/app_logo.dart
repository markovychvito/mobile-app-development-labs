import 'package:material_ui/material_ui.dart';
import 'package:my_project/ui/theme/app_spacing.dart';

/// Логотип застосунку: іконка в кольоровому квадраті та назва.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s),
            child: Icon(Icons.dns_outlined, color: scheme.onPrimary, size: 32),
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Text(
          'HomeLab',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
