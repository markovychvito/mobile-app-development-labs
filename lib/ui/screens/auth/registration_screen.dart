import 'package:material_ui/material_ui.dart';
import 'package:my_project/app/app_routes.dart';
import 'package:my_project/domain/exceptions/app_exception.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';
import 'package:my_project/domain/validation/validators.dart';
import 'package:my_project/ui/theme/app_spacing.dart';
import 'package:my_project/ui/widgets/app_text_field.dart';
import 'package:my_project/ui/widgets/auth_layout.dart';
import 'package:my_project/ui/widgets/error_banner.dart';
import 'package:my_project/ui/widgets/link_prompt.dart';
import 'package:my_project/ui/widgets/primary_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({required this.authRepository, super.key});

  final IAuthRepository authRepository;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  bool _isLoading = false;
  String? _error;

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await widget.authRepository.register(
        name: _name.text,
        email: _email.text,
        password: _password.text,
      );
      if (!mounted) return;
      // Очищаємо стек: після реєстрації назад на форми не повертаємось.
      await Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    for (final controller in [_name, _email, _password, _confirm]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AuthLayout(
        title: 'Реєстрація',
        subtitle: 'Створіть акаунт, щоб додати свої сервери',
        children: [
          if (_error case final error?) ErrorBanner(message: error),
          AppTextField(
            controller: _name,
            enabled: !_isLoading,
            label: "Ім'я",
            icon: Icons.person_outline,
            validator: Validators.name,
          ),
          AppTextField(
            controller: _email,
            enabled: !_isLoading,
            label: 'Електронна пошта',
            hint: 'name@example.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          AppTextField(
            controller: _password,
            enabled: !_isLoading,
            label: 'Пароль',
            hint: 'Мінімум 8 символів, літери та цифри',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: Validators.password,
          ),
          AppTextField(
            controller: _confirm,
            enabled: !_isLoading,
            label: 'Підтвердіть пароль',
            icon: Icons.lock_reset,
            isPassword: true,
            textInputAction: TextInputAction.done,
            validator: (value) =>
                Validators.confirmPassword(value, _password.text),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.s),
          PrimaryButton(
            label: 'Створити акаунт',
            icon: Icons.person_add_alt_1,
            isLoading: _isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.m),
          LinkPrompt(
            question: 'Вже маєте акаунт?',
            actionLabel: 'Увійти',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
