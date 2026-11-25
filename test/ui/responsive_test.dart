import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:my_project/app/app_dependencies.dart';
import 'package:my_project/ui/screens/auth/login_screen.dart';
import 'package:my_project/ui/screens/auth/registration_screen.dart';
import 'package:my_project/ui/screens/dashboard/dashboard_screen.dart';
import 'package:my_project/ui/screens/profile/profile_screen.dart';
import 'package:my_project/ui/theme/app_theme.dart';

import 'test_harness.dart';

/// iPhone SE (1st gen), iPhone 8, планшет.
const Map<String, Size> screenSizes = {
  'iPhone SE': Size(320, 568),
  'iPhone 8': Size(375, 667),
  'Tablet': Size(1024, 1366),
};

final Map<String, Widget Function(AppDependencies)> screens = {
  'Login': (deps) => LoginScreen(authRepository: deps.authRepository),
  'Registration': (deps) =>
      RegistrationScreen(authRepository: deps.authRepository),
  'Dashboard': (deps) => DashboardScreen(
    authRepository: deps.authRepository,
    deviceRepository: deps.deviceRepository,
  ),
  'Profile': (deps) => ProfileScreen(
    authRepository: deps.authRepository,
    deviceRepository: deps.deviceRepository,
  ),
};

void main() {
  group('Responsive layout (no RenderFlex overflow)', () {
    for (final screen in screens.entries) {
      for (final size in screenSizes.entries) {
        testWidgets('${screen.key} on ${size.key}', (tester) async {
          final deps = await createDependencies();
          await seedUser(
            deps,
            deviceNames: [
              'pi-node-01',
              'Дуже довга назва пристрою 2026',
              'router-main',
              'nas-home',
              'ups-rack',
            ],
          );
          setScreenSize(tester, size.value);
          await tester.pumpWidget(
            MaterialApp(theme: AppTheme.light, home: screen.value(deps)),
          );
          await tester.pumpAndSettle();

          // Overflow під час layout кидає виняток, який тест перехоплює.
          expect(tester.takeException(), isNull);
        });
      }
    }
  });
}
