import 'package:material_ui/material_ui.dart';

/// Повноекранний індикатор завантаження.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
