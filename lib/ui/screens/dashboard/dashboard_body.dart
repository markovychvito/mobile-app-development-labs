import 'package:material_ui/material_ui.dart';
import 'package:my_project/domain/models/device.dart';
import 'package:my_project/domain/models/user.dart';
import 'package:my_project/ui/theme/app_spacing.dart';
import 'package:my_project/ui/widgets/device_card.dart';
import 'package:my_project/ui/widgets/device_grid.dart';
import 'package:my_project/ui/widgets/device_type_ui.dart';
import 'package:my_project/ui/widgets/empty_state.dart';
import 'package:my_project/ui/widgets/greeting_header.dart';
import 'package:my_project/ui/widgets/responsive_body.dart';
import 'package:my_project/ui/widgets/section_title.dart';
import 'package:my_project/ui/widgets/stat_tile.dart';
import 'package:my_project/ui/widgets/stats_row.dart';

/// Розмітка головного екрана. Stateless: отримує готові дані
/// й повідомляє про дії користувача через колбеки.
class DashboardBody extends StatelessWidget {
  const DashboardBody({
    required this.user,
    required this.devices,
    required this.onOpen,
    required this.onToggle,
    super.key,
  });

  final User user;
  final List<Device> devices;
  final ValueChanged<Device> onOpen;
  final void Function(Device device, bool isOn) onToggle;

  @override
  Widget build(BuildContext context) {
    final onCount = devices.where((device) => device.isOn).length;
    final locationCount = devices
        .map((device) => device.location)
        .toSet()
        .length;

    return SingleChildScrollView(
      // Додатковий відступ знизу, щоб FAB не перекривав останні картки.
      padding: const EdgeInsets.only(bottom: 88),
      child: ResponsiveBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GreetingHeader(
              title: 'Привіт, ${user.firstName}!',
              subtitle: 'Стан обладнання вашої лабораторії',
            ),
            const SizedBox(height: AppSpacing.l),
            StatsRow(
              children: [
                StatTile(
                  icon: Icons.devices_other,
                  value: '${devices.length}',
                  label: 'Пристроїв',
                ),
                StatTile(
                  icon: Icons.power_settings_new,
                  value: '$onCount',
                  label: 'Увімкнено',
                ),
                StatTile(
                  icon: Icons.place_outlined,
                  value: '$locationCount',
                  label: 'Локацій',
                ),
              ],
            ),
            SectionTitle(
              title: 'Пристрої',
              trailing: Text('$onCount з ${devices.length} увімкнено'),
            ),
            if (devices.isEmpty)
              const EmptyState(
                icon: Icons.add_home_outlined,
                title: 'Поки що немає пристроїв',
                message: 'Натисніть «Додати пристрій», щоб підключити перший',
              )
            else
              DeviceGrid(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return DeviceCard(
                    key: ValueKey(device.id),
                    name: device.name,
                    location: device.location,
                    icon: device.type.icon,
                    isOn: device.isOn,
                    onTap: () => onOpen(device),
                    onToggle: (isOn) => onToggle(device, isOn),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
