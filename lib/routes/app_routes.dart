import 'package:material_ui/material_ui.dart';
import 'package:my_project/screens/dashboard_screen.dart';
import 'package:my_project/screens/login_screen.dart';
import 'package:my_project/screens/profile_screen.dart';
import 'package:my_project/screens/registration_screen.dart';

/// Іменовані маршрути застосунку (Navigator 1.0).
abstract final class AppRoutes {
  static const String login = '/login';
  static const String registration = '/registration';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';

  static final Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginScreen(),
    registration: (_) => const RegistrationScreen(),
    dashboard: (_) => const DashboardScreen(),
    profile: (_) => const ProfileScreen(),
  };
}
