import 'package:material_ui/material_ui.dart';
import 'package:my_project/ui/theme/app_colors.dart';
import 'package:my_project/ui/theme/app_spacing.dart';
import 'package:my_project/ui/widgets/app_logo.dart';

/// Спільний каркас для екранів входу та реєстрації.
///
/// SingleChildScrollView не дає контенту переповнитись, коли відкрита
/// клавіатура або екран низький, а ConstrainedBox тримає форму вузькою
/// на планшеті.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    required this.title,
    required this.subtitle,
    required this.children,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxFormWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppLogo(),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    title,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
