import 'package:material_ui/material_ui.dart';
import 'package:my_project/mock/mock_data.dart';
import 'package:my_project/routes/app_routes.dart';
import 'package:my_project/theme/app_spacing.dart';
import 'package:my_project/widgets/device_card.dart';
import 'package:my_project/widgets/device_grid.dart';
import 'package:my_project/widgets/greeting_header.dart';
import 'package:my_project/widgets/responsive_body.dart';
import 'package:my_project/widgets/section_title.dart';
import 'package:my_project/widgets/stat_tile.dart';
import 'package:my_project/widgets/stats_row.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const devices = MockData.devices;
    final onlineCount = devices.where((device) => device.isOn).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя лабораторія'),
        actions: [
          IconButton(
            tooltip: 'Профіль',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingHeader(
                title: 'Привіт, Андрію!',
                subtitle: 'Усі сервери працюють у штатному режимі',
              ),
              const SizedBox(height: AppSpacing.l),
              const StatsRow(
                children: [
                  StatTile(
                    icon: Icons.thermostat,
                    value: '26 °C',
                    label: 'Темп. стійки',
                  ),
                  StatTile(
                    icon: Icons.speed,
                    value: '18%',
                    label: 'Навантаження',
                  ),
                  StatTile(
                    icon: Icons.bolt,
                    value: '86 Вт',
                    label: 'Споживання',
                  ),
                ],
              ),
              SectionTitle(
                title: 'Пристрої',
                trailing: Text('$onlineCount з ${devices.length} увімкнено'),
              ),
              DeviceGrid(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return DeviceCard(
                    name: device.name,
                    location: device.location,
                    status: device.status,
                    icon: device.icon,
                    isOn: device.isOn,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
