import 'package:material_ui/material_ui.dart';
import 'package:my_project/app/app_dependencies.dart';
import 'package:my_project/app/app_routes.dart';
import 'package:my_project/ui/theme/app_theme.dart';

class HomeLabApp extends StatelessWidget {
  const HomeLabApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeLab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.startup,
      routes: AppRoutes.build(dependencies),
    );
  }
}
