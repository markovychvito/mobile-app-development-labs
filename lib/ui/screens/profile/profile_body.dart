import 'package:material_ui/material_ui.dart';
import 'package:my_project/domain/models/user.dart';
import 'package:my_project/ui/theme/app_spacing.dart';
import 'package:my_project/ui/widgets/info_tile.dart';
import 'package:my_project/ui/widgets/primary_button.dart';
import 'package:my_project/ui/widgets/profile_header.dart';
import 'package:my_project/ui/widgets/responsive_body.dart';
import 'package:my_project/ui/widgets/section_title.dart';

/// Розмітка профілю з даними авторизованого користувача.
class ProfileBody extends StatelessWidget {
  const ProfileBody({
    required this.user,
    required this.deviceCount,
    required this.onEditName,
    required this.onLogout,
    super.key,
  });

  final User user;
  final int deviceCount;
  final VoidCallback onEditName;
  final VoidCallback onLogout;

  static String _formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(date.day)}.${twoDigits(date.month)}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveBody(
        maxWidth: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileHeader(name: user.name, email: user.email),
            const SectionTitle(title: 'Особисті дані'),
            InfoTile(
              icon: Icons.person_outline,
              label: "Ім'я",
              value: user.name,
              onTap: onEditName,
            ),
            InfoTile(
              icon: Icons.email_outlined,
              label: 'Електронна пошта',
              value: user.email,
            ),
            InfoTile(
              icon: Icons.calendar_today_outlined,
              label: 'Дата реєстрації',
              value: _formatDate(user.createdAt),
            ),
            const SectionTitle(title: 'Моя лабораторія'),
            InfoTile(
              icon: Icons.devices_other,
              label: 'Підключені пристрої',
              value: '$deviceCount',
            ),
            const SizedBox(height: AppSpacing.l),
            PrimaryButton(
              label: 'Вийти з акаунта',
              icon: Icons.logout,
              variant: ButtonVariant.outlined,
              onPressed: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}
