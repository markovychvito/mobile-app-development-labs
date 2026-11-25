import 'package:material_ui/material_ui.dart';
import 'package:my_project/app/app.dart';
import 'package:my_project/app/app_dependencies.dart';
import 'package:my_project/data/shared_prefs_auth_repository.dart';
import 'package:my_project/data/shared_prefs_device_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Composition root: єдине місце, яке знає про конкретні реалізації.
/// Щоб перейти на REST API, достатньо замінити тут два рядки
/// на `RestAuthRepository(...)` і `RestDeviceRepository(...)`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final dependencies = AppDependencies(
    authRepository: SharedPrefsAuthRepository(prefs),
    deviceRepository: SharedPrefsDeviceRepository(prefs),
  );

  runApp(HomeLabApp(dependencies: dependencies));
}
