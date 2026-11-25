import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:my_project/app.dart';
import 'package:my_project/screens/dashboard_screen.dart';
import 'package:my_project/screens/login_screen.dart';
import 'package:my_project/screens/profile_screen.dart';
import 'package:my_project/screens/registration_screen.dart';
import 'package:my_project/theme/app_theme.dart';

/// Розміри екранів: iPhone SE (1st gen), iPhone 8, планшет.
const Map<String, Size> screenSizes = {
  'iPhone SE': Size(320, 568),
  'iPhone 8': Size(375, 667),
  'Tablet': Size(1024, 1366),
};

const Map<String, Widget> screens = {
  'Login': LoginScreen(),
  'Registration': RegistrationScreen(),
  'Dashboard': DashboardScreen(),
  'Profile': ProfileScreen(),
};

Future<void> pumpAtSize(WidgetTester tester, Widget screen, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: screen));
  await tester.pumpAndSettle();
}

void main() {
  group('Responsive layout (no RenderFlex overflow)', () {
    for (final screen in screens.entries) {
      for (final size in screenSizes.entries) {
        testWidgets('${screen.key} on ${size.key}', (tester) async {
          await pumpAtSize(tester, screen.value, size.value);
          // Overflow під час layout кидає виняток, який тест перехоплює.
          expect(tester.takeException(), isNull);
        });
      }
    }
  });

  testWidgets('Navigation: login -> registration -> back', (tester) async {
    await tester.pumpWidget(const SmartHomeApp());
    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.tap(find.text('Зареєструватися'));
    await tester.pumpAndSettle();
    expect(find.byType(RegistrationScreen), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Увійти'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Navigation: login -> dashboard -> profile -> logout', (
    tester,
  ) async {
    await tester.pumpWidget(const SmartHomeApp());

    await tester.tap(find.widgetWithText(FilledButton, 'Увійти'));
    await tester.pumpAndSettle();
    expect(find.byType(DashboardScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Профіль'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);

    await tester.ensureVisible(find.text('Вийти з акаунта'));
    await tester.tap(find.text('Вийти з акаунта'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
