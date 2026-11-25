import 'package:material_ui/material_ui.dart';
import 'package:my_project/routes/app_routes.dart';
import 'package:my_project/theme/app_theme.dart';

class HomeLabApp extends StatelessWidget {
  const HomeLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeLab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
