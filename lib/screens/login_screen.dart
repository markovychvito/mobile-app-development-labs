import 'package:material_ui/material_ui.dart';
import 'package:my_project/routes/app_routes.dart';
import 'package:my_project/theme/app_spacing.dart';
import 'package:my_project/widgets/app_text_field.dart';
import 'package:my_project/widgets/auth_layout.dart';
import 'package:my_project/widgets/link_prompt.dart';
import 'package:my_project/widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Вхід',
      subtitle: 'Керуйте своїм розумним домом з будь-якого місця',
      children: [
        const AppTextField(
          label: 'Електронна пошта',
          hint: 'name@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const AppTextField(
          label: 'Пароль',
          icon: Icons.lock_outline,
          isPassword: true,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: AppSpacing.s),
        PrimaryButton(
          label: 'Увійти',
          icon: Icons.login,
          // pushReplacement: після входу кнопка «Назад» не веде на логін.
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
        ),
        const SizedBox(height: AppSpacing.m),
        LinkPrompt(
          question: 'Немає акаунта?',
          actionLabel: 'Зареєструватися',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.registration),
        ),
      ],
    );
  }
}
