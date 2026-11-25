import 'package:material_ui/material_ui.dart';
import 'package:my_project/theme/app_spacing.dart';

/// Сітка пристроїв, яка сама обирає кількість колонок
/// за доступною шириною (LayoutBuilder).
class DeviceGrid extends StatelessWidget {
  const DeviceGrid({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  static const double _cardHeight = 150;

  static int columnsFor(double width) {
    if (width >= 900) return 4;
    if (width >= AppSpacing.tabletBreakpoint) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnsFor(constraints.maxWidth),
            crossAxisSpacing: AppSpacing.s,
            mainAxisSpacing: AppSpacing.s,
            // Фіксована висота замість aspect ratio: картка не «сплющиться»
            // і не переповниться на дуже широкому чи вузькому екрані.
            mainAxisExtent: _cardHeight,
          ),
        );
      },
    );
  }
}
