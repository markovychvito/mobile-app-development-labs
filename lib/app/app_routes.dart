import 'package:material_ui/material_ui.dart';
import 'package:my_project/app/app_dependencies.dart';
import 'package:my_project/ui/screens/auth/login_screen.dart';
import 'package:my_project/ui/screens/auth/registration_screen.dart';
import 'package:my_project/ui/screens/dashboard/dashboard_screen.dart';
import 'package:my_project/ui/screens/profile/profile_screen.dart';
import 'package:my_project/ui/screens/startup/startup_screen.dart';

/// Іменовані маршрути (Navigator 1.0). Залежності передаються
/// в екрани через конструктор.
abstract final class AppRoutes {
  static const String startup = '/';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> build(AppDependencies deps) {
    return {
      startup: (_) => StartupScreen(authRepository: deps.authRepository),
      login: (_) => LoginScreen(authRepository: deps.authRepository),
      registration: (_) =>
          RegistrationScreen(authRepository: deps.authRepository),
      dashboard: (_) => DashboardScreen(
        authRepository: deps.authRepository,
        deviceRepository: deps.deviceRepository,
      ),
      profile: (_) => ProfileScreen(
        authRepository: deps.authRepository,
        deviceRepository: deps.deviceRepository,
      ),
    };
  }
}
