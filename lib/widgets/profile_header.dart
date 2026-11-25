import 'package:material_ui/material_ui.dart';
import 'package:my_project/theme/app_colors.dart';
import 'package:my_project/theme/app_spacing.dart';

/// Аватар з ініціалами, ім'я та пошта користувача.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.name, required this.email, super.key});

  final String name;
  final String email;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: scheme.primaryContainer,
          child: Text(
            _initials,
            style: textTheme.headlineSmall?.copyWith(
              color: scheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        Text(
          name,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          email,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}
