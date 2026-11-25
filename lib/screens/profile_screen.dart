import 'package:material_ui/material_ui.dart';
import 'package:my_project/mock/mock_data.dart';
import 'package:my_project/routes/app_routes.dart';
import 'package:my_project/theme/app_spacing.dart';
import 'package:my_project/widgets/info_tile.dart';
import 'package:my_project/widgets/primary_button.dart';
import 'package:my_project/widgets/profile_header.dart';
import 'package:my_project/widgets/responsive_body.dart';
import 'package:my_project/widgets/section_title.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          maxWidth: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProfileHeader(
                name: MockData.userName,
                email: MockData.userEmail,
              ),
              const SectionTitle(title: 'Особисті дані'),
              const InfoTile(
                icon: Icons.phone_outlined,
                label: 'Телефон',
                value: MockData.userPhone,
              ),
              const InfoTile(
                icon: Icons.location_city_outlined,
                label: 'Місто',
                value: MockData.userCity,
              ),
              const InfoTile(
                icon: Icons.calendar_today_outlined,
                label: 'З нами з',
                value: MockData.memberSince,
              ),
              const SectionTitle(title: 'Моя лабораторія'),
              InfoTile(
                icon: Icons.devices_other,
                label: 'Підключені пристрої',
                value: '${MockData.devices.length}',
              ),
              const SizedBox(height: AppSpacing.l),
              PrimaryButton(
                label: 'Вийти з акаунта',
                icon: Icons.logout,
                variant: ButtonVariant.outlined,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
