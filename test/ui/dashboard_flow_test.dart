import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:my_project/ui/screens/auth/login_screen.dart';
import 'package:my_project/ui/screens/dashboard/dashboard_screen.dart';
import 'package:my_project/ui/screens/profile/profile_screen.dart';

import 'test_harness.dart';

void main() {
  testWidgets('CRUD: add, toggle, rename and delete a device', (tester) async {
    final deps = await createDependencies();
    await seedUser(deps);
    await pumpApp(tester, deps);
    expect(find.byType(DashboardScreen), findsOneWidget);

    // Create
    await tapAndSettle(tester, find.text('Додати пристрій'));
    await enterField(tester, 'Назва', 'pi-node-01');
    await enterField(tester, 'Розташування', 'Полиця 2');
    await tapAndSettle(tester, find.text('Зберегти'));
    expect(find.text('pi-node-01'), findsOneWidget);
    expect(find.text('Вимкнено'), findsOneWidget);

    // Update: перемикач
    await tapAndSettle(tester, find.byType(Switch));
    expect(find.text('Вимкнено'), findsNothing);
    final stored = await deps.deviceRepository.fetchAll(testEmail);
    expect(stored.single.isOn, isTrue);

    // Update: редагування назви
    await tapAndSettle(tester, find.text('pi-node-01'));
    await enterField(tester, 'Назва', 'pi-node-02');
    await tapAndSettle(tester, find.text('Зберегти'));
    expect(find.text('pi-node-02'), findsOneWidget);
    expect(find.text('pi-node-01'), findsNothing);

    // Delete (з підтвердженням)
    await tapAndSettle(tester, find.text('pi-node-02'));
    await tapAndSettle(tester, find.text('Видалити пристрій'));
    await tapAndSettle(tester, find.widgetWithText(TextButton, 'Видалити'));
    expect(find.text('Поки що немає пристроїв'), findsOneWidget);
    expect(await deps.deviceRepository.fetchAll(testEmail), isEmpty);
  });

  testWidgets('device form validates input', (tester) async {
    final deps = await createDependencies();
    await seedUser(deps);
    await pumpApp(tester, deps);

    await tapAndSettle(tester, find.text('Додати пристрій'));
    await tapAndSettle(tester, find.text('Зберегти'));

    expect(find.text('Вкажіть назву'), findsOneWidget);
    expect(find.text('Вкажіть розташування'), findsOneWidget);
    expect(await deps.deviceRepository.fetchAll(testEmail), isEmpty);
  });

  testWidgets('restart keeps the session and the devices', (tester) async {
    final deps = await createDependencies();
    await seedUser(deps, deviceNames: ['rack-sensor']);
    await pumpApp(tester, deps);

    // «Перезапуск»: прибираємо дерево віджетів і будуємо застосунок
    // з нуля поверх того самого сховища.
    await tester.pumpWidget(const SizedBox());
    final restarted = await createDependencies(resetStorage: false);
    await pumpApp(tester, restarted);

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('rack-sensor'), findsOneWidget);
  });

  testWidgets('profile: shows user data, renames, logs out', (tester) async {
    final deps = await createDependencies();
    await seedUser(deps, deviceNames: ['mini-pc', 'nas-home']);
    await pumpApp(tester, deps);

    await tapAndSettle(tester, find.byTooltip('Профіль'));
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text(testEmail), findsNWidgets(2));
    expect(find.text('2'), findsOneWidget);

    await tapAndSettle(tester, find.text("Ім'я"));
    await tester.enterText(find.byType(TextFormField), 'Андрій Коваль');
    await tapAndSettle(tester, find.widgetWithText(FilledButton, 'Зберегти'));
    expect(find.text('Андрій Коваль'), findsNWidgets(2));

    // Повернення на головний екран підхоплює нове ім'я.
    await tapAndSettle(tester, find.byType(BackButton));
    expect(find.text('Привіт, Андрій!'), findsOneWidget);

    await tapAndSettle(tester, find.byTooltip('Профіль'));
    await tapAndSettle(tester, find.text('Вийти з акаунта'));
    await tapAndSettle(tester, find.widgetWithText(TextButton, 'Вийти'));
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(await deps.authRepository.currentUser(), isNull);
  });
}
