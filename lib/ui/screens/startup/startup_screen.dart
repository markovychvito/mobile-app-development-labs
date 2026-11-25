import 'package:material_ui/material_ui.dart';
import 'package:my_project/app/app_routes.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';
import 'package:my_project/ui/theme/app_spacing.dart';
import 'package:my_project/ui/widgets/app_logo.dart';

/// Перший екран: перевіряє, чи збережена сесія, і веде
/// на головний екран (якщо так) або на вхід.
class StartupScreen extends StatefulWidget {
  const StartupScreen({required this.authRepository, super.key});

  final IAuthRepository authRepository;

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    final user = await widget.authRepository.currentUser();
    if (!mounted) return;
    await Navigator.pushReplacementNamed(
      context,
      user == null ? AppRoutes.login : AppRoutes.dashboard,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogo(),
            SizedBox(height: AppSpacing.l),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
