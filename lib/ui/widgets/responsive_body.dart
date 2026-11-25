import 'package:material_ui/material_ui.dart';
import 'package:my_project/ui/theme/app_spacing.dart';

/// Центрує контент, обмежує його ширину на планшетах і підбирає
/// горизонтальні відступи залежно від ширини екрана (MediaQuery).
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({
    required this.child,
    this.maxWidth = AppSpacing.maxContentWidth,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= AppSpacing.tabletBreakpoint
        ? AppSpacing.l
        : AppSpacing.m;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontal,
            vertical: AppSpacing.m,
          ),
          child: child,
        ),
      ),
    );
  }
}
