import 'package:material_ui/material_ui.dart';
import 'package:my_project/routes/app_routes.dart';
import 'package:my_project/theme/app_spacing.dart';
import 'package:my_project/widgets/app_text_field.dart';
import 'package:my_project/widgets/auth_layout.dart';
import 'package:my_project/widgets/link_prompt.dart';
import 'package:my_project/widgets/primary_button.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Реєстрація',
      subtitle: 'Створіть акаунт, щоб додати свої сервери',
      children: [
        const AppTextField(label: "Ім'я", icon: Icons.person_outline),
        const AppTextField(
          label: 'Електронна пошта',
          hint: 'name@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const AppTextField(
          label: 'Пароль',
          hint: 'Мінімум 8 символів',
          icon: Icons.lock_outline,
          isPassword: true,
        ),
        const AppTextField(
          label: 'Підтвердіть пароль',
          icon: Icons.lock_reset,
          isPassword: true,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: AppSpacing.s),
        PrimaryButton(
          label: 'Створити акаунт',
          icon: Icons.person_add_alt_1,
          // Очищаємо стек: після реєстрації назад на форми не повертаємось.
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (route) => false,
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        LinkPrompt(
          question: 'Вже маєте акаунт?',
          actionLabel: 'Увійти',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
