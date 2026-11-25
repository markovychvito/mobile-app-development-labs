import 'package:material_ui/material_ui.dart';
import 'package:my_project/ui/theme/app_colors.dart';
import 'package:my_project/ui/theme/app_spacing.dart';
import 'package:my_project/ui/widgets/icon_badge.dart';

/// Картка IoT-пристрою. Усі дані приходять через конструктор,
/// тому одна картка підходить для будь-якого пристрою.
class DeviceCard extends StatelessWidget {
  const DeviceCard({
    required this.name,
    required this.location,
    required this.icon,
    required this.isOn,
    this.onTap,
    this.onToggle,
    super.key,
  });

  final String name;
  final String location;
  final IconData icon;
  final bool isOn;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = isOn
        ? Theme.of(context).colorScheme.primary
        : AppColors.offline;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconBadge(icon: icon, color: accent),
                  const Spacer(),
                  Switch(value: isOn, onChanged: onToggle),
                ],
              ),
              const Spacer(),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                isOn ? 'Увімкнено' : 'Вимкнено',
                style: textTheme.labelMedium?.copyWith(color: accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
