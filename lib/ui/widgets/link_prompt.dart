import 'package:material_ui/material_ui.dart';
import 'package:my_project/ui/theme/app_colors.dart';

/// Рядок «Питання? Дія» під формою, напр. «Немає акаунта? Зареєструватися».
/// Wrap переносить кнопку на новий рядок на вузьких екранах.
class LinkPrompt extends StatelessWidget {
  const LinkPrompt({
    required this.question,
    required this.actionLabel,
    required this.onPressed,
    super.key,
  });

  final String question;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(question, style: const TextStyle(color: AppColors.textMuted)),
        TextButton(onPressed: onPressed, child: Text(actionLabel)),
      ],
    );
  }
}
