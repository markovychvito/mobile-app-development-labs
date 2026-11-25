import 'package:material_ui/material_ui.dart';
import 'package:my_project/theme/app_spacing.dart';

/// Іконка на круглому напівпрозорому фоні того ж кольору.
class IconBadge extends StatelessWidget {
  const IconBadge({required this.icon, required this.color, super.key});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s),
        child: Icon(icon, color: color),
      ),
    );
  }
}
