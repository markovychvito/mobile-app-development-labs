import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:my_project/ui/screens/auth/login_screen.dart';
import 'package:my_project/ui/screens/auth/registration_screen.dart';
import 'package:my_project/ui/screens/dashboard/dashboard_screen.dart';
import 'package:my_project/ui/widgets/error_banner.dart';

import 'test_harness.dart';

void main() {
  Future<void> openRegistration(WidgetTester tester) {
    return tapAndSettle(tester, find.text('Зареєструватися'));
  }

  testWidgets('registration: invalid data shows errors and is blocked', (
    tester,
  ) async {
    final deps = await createDependencies();
    await pumpApp(tester, deps);
    await openRegistration(tester);

    await enterField(tester, "Ім'я", 'Andrii2');
    await enterField(tester, 'Електронна пошта', 'andrii.mail');
    await enterField(tester, 'Пароль', '123');
    await enterField(tester, 'Підтвердіть пароль', '321');
    await tapAndSettle(tester, find.text('Створити акаунт'));

    expect(find.text("Ім'я не може містити цифри"), findsOneWidget);
    expect(find.text('Пошта повинна містити символ @'), findsOneWidget);
    expect(find.textContaining('щонайменше 8'), findsOneWidget);
    expect(find.text('Паролі не збігаються'), findsOneWidget);
    expect(find.byType(RegistrationScreen), findsOneWidget);
    expect(await deps.authRepository.currentUser(), isNull);
  });

  testWidgets('registration: valid data opens the dashboard', (tester) async {
    final deps = await createDependencies();
    await pumpApp(tester, deps);
    await openRegistration(tester);

    await enterField(tester, "Ім'я", 'Олена Коваль');
    await enterField(tester, 'Електронна пошта', 'olena@mail.com');
    await enterField(tester, 'Пароль', testPassword);
    await enterField(tester, 'Підтвердіть пароль', testPassword);
    await tapAndSettle(tester, find.text('Створити акаунт'));

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Привіт, Олена!'), findsOneWidget);
    expect(find.text('Поки що немає пристроїв'), findsOneWidget);
  });

  testWidgets('registration: taken email shows an error', (tester) async {
    final deps = await createDependencies();
    await seedUser(deps);
    await deps.authRepository.logout();
    await pumpApp(tester, deps);
    await openRegistration(tester);

    await enterField(tester, "Ім'я", 'Інший Андрій');
    await enterField(tester, 'Електронна пошта', testEmail);
    await enterField(tester, 'Пароль', testPassword);
    await enterField(tester, 'Підтвердіть пароль', testPassword);
    await tapAndSettle(tester, find.text('Створити акаунт'));

    expect(
      find.widgetWithText(ErrorBanner, 'Користувач з такою поштою вже існує'),
      findsOneWidget,
    );
    expect(find.byType(RegistrationScreen), findsOneWidget);
  });

  testWidgets('login: wrong password fails, correct one succeeds', (
    tester,
  ) async {
    final deps = await createDependencies();
    await seedUser(deps);
    await deps.authRepository.logout();
    await pumpApp(tester, deps);
    expect(find.byType(LoginScreen), findsOneWidget);

    final loginButton = find.widgetWithText(FilledButton, 'Увійти');
    await enterField(tester, 'Електронна пошта', testEmail);
    await enterField(tester, 'Пароль', 'wrong123');
    await tapAndSettle(tester, loginButton);
    expect(find.text('Невірна пошта або пароль'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);

    await enterField(tester, 'Пароль', testPassword);
    await tapAndSettle(tester, loginButton);
    expect(find.byType(DashboardScreen), findsOneWidget);
  });

  testWidgets('login: empty form is not sent', (tester) async {
    final deps = await createDependencies();
    await pumpApp(tester, deps);

    await tapAndSettle(tester, find.widgetWithText(FilledButton, 'Увійти'));

    expect(find.text('Введіть електронну пошту'), findsOneWidget);
    expect(find.text('Введіть пароль'), findsOneWidget);
  });
}
