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

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.authRepository, super.key});

  final IAuthRepository authRepository;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _isLoading = false;
  String? _error;

  Future<void> _submit() async {
    // Невалідна форма блокує операцію: до сховища навіть не звертаємось.
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await widget.authRepository.login(
        email: _email.text,
        password: _password.text,
      );
      if (!mounted) return;
      await Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
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
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AuthLayout(
        title: 'Вхід',
        subtitle: 'Стежте за своєю домашньою лабораторією звідусіль',
        children: [
          if (_error case final error?) ErrorBanner(message: error),
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
            icon: Icons.lock_outline,
            isPassword: true,
            textInputAction: TextInputAction.done,
            validator: Validators.loginPassword,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.s),
          PrimaryButton(
            label: 'Увійти',
            icon: Icons.login,
            isLoading: _isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.m),
          LinkPrompt(
            question: 'Немає акаунта?',
            actionLabel: 'Зареєструватися',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.registration),
          ),
        ],
      ),
    );
  }
}
