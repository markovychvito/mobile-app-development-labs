import 'package:material_ui/material_ui.dart';

/// AppBar головного екрана: показує спінер, поки триває операція
/// зі сховищем, і кнопку переходу в профіль.
class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({
    required this.isBusy,
    required this.onProfile,
    super.key,
  });

  final bool isBusy;
  final VoidCallback? onProfile;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Після входу «назад» на екран логіну не потрібен.
      automaticallyImplyLeading: false,
      title: const Text('Моя лабораторія'),
      actions: [
        if (isBusy)
          const Padding(
            padding: EdgeInsets.all(12),
            child: SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ),
        IconButton(
          tooltip: 'Профіль',
          icon: const Icon(Icons.account_circle_outlined),
          onPressed: onProfile,
        ),
      ],
    );
  }
}
