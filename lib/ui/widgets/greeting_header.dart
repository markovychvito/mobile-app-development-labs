import 'package:material_ui/material_ui.dart';
import 'package:my_project/ui/theme/app_colors.dart';
import 'package:my_project/ui/theme/app_spacing.dart';

/// Привітання вгорі головного екрана.
class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}
