import 'package:material_ui/material_ui.dart';

extension SnackBarMessage on BuildContext {
  /// Коротке сповіщення внизу екрана (напр. про помилку операції).
  void showMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}
