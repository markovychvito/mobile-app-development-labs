import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:my_project/app/app.dart';
import 'package:my_project/app/app_dependencies.dart';
import 'package:my_project/data/shared_prefs_auth_repository.dart';
import 'package:my_project/data/shared_prefs_device_repository.dart';
import 'package:my_project/domain/models/device.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String testEmail = 'andrii@homelab.ua';
const String testPassword = 'smart123';

/// Справжні репозиторії поверх in-memory SharedPreferences, без затримки.
/// [resetStorage] = false імітує перезапуск: сховище лишається тим самим.
Future<AppDependencies> createDependencies({bool resetStorage = true}) async {
  if (resetStorage) SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return AppDependencies(
    authRepository: SharedPrefsAuthRepository(prefs, latency: Duration.zero),
    deviceRepository: SharedPrefsDeviceRepository(
      prefs,
      latency: Duration.zero,
    ),
  );
}

/// Реєструє тестового користувача (сесія відкрита) і додає пристрої.
Future<void> seedUser(
  AppDependencies deps, {
  List<String> deviceNames = const [],
}) async {
  await deps.authRepository.register(
    name: 'Андрій Шевченко',
    email: testEmail,
    password: testPassword,
  );
  for (final name in deviceNames) {
    await deps.deviceRepository.add(
      testEmail,
      name: name,
      location: 'Кабінет',
      type: DeviceType.raspberryPi,
    );
  }
}

void setScreenSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> pumpApp(WidgetTester tester, AppDependencies deps) async {
  setScreenSize(tester, const Size(400, 900));
  await tester.pumpWidget(HomeLabApp(dependencies: deps));
  await tester.pumpAndSettle();
}

Future<void> enterField(WidgetTester tester, String label, String text) {
  return tester.enterText(find.widgetWithText(TextFormField, label), text);
}

Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
