import 'package:material_ui/material_ui.dart';
import 'package:my_project/ui/theme/app_spacing.dart';

/// Рядок карток, які порівну ділять доступну ширину (Expanded).
class StatsRow extends StatelessWidget {
  const StatsRow({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.s),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}
