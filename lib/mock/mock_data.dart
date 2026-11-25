import 'package:material_ui/material_ui.dart';

/// Статичний пристрій для відображення на UI (заглушка для ЛР2).
class MockDevice {
  const MockDevice({
    required this.name,
    required this.location,
    required this.status,
    required this.icon,
    required this.isOn,
  });

  final String name;
  final String location;
  final String status;
  final IconData icon;
  final bool isOn;
}

/// Mock-дані, які візуально відповідають реальному контенту.
abstract final class MockData {
  static const String userName = 'Андрій Шевченко';
  static const String userEmail = 'andrii@homelab.ua';
  static const String userPhone = '+380 67 123 45 67';
  static const String userCity = 'Львів';
  static const String memberSince = 'листопад 2026';

  static const List<MockDevice> devices = [
    MockDevice(
      name: 'pi-node-01',
      location: 'Стійка, полиця 1',
      status: 'CPU 48 °C · 23%',
      icon: Icons.developer_board,
      isOn: true,
    ),
    MockDevice(
      name: 'nas-home',
      location: 'Стійка, полиця 2',
      status: 'Диск 61% зайнято',
      icon: Icons.storage,
      isOn: true,
    ),
    MockDevice(
      name: 'router-main',
      location: 'Коридор',
      status: 'Uptime 14 днів',
      icon: Icons.router_outlined,
      isOn: true,
    ),
    MockDevice(
      name: 'mini-pc-docker',
      location: 'Кабінет',
      status: 'Вимкнено',
      icon: Icons.computer,
      isOn: false,
    ),
    MockDevice(
      name: 'ups-rack',
      location: 'Стійка, низ',
      status: 'Заряд 100%',
      icon: Icons.battery_charging_full,
      isOn: true,
    ),
    MockDevice(
      name: 'rack-sensor',
      location: 'Стійка, верх',
      status: '26 °C · 38%',
      icon: Icons.thermostat,
      isOn: true,
    ),
  ];
}
