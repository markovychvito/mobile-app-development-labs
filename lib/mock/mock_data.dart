import 'package:material_ui/material_ui.dart';

/// Статичний пристрій для відображення на UI (заглушка для ЛР2).
class MockDevice {
  const MockDevice({
    required this.name,
    required this.room,
    required this.status,
    required this.icon,
    required this.isOn,
  });

  final String name;
  final String room;
  final String status;
  final IconData icon;
  final bool isOn;
}

/// Mock-дані, які візуально відповідають реальному контенту.
abstract final class MockData {
  static const String userName = 'Андрій Шевченко';
  static const String userEmail = 'andrii@smarthome.ua';
  static const String userPhone = '+380 67 123 45 67';
  static const String userCity = 'Львів';
  static const String memberSince = 'листопад 2026';

  static const List<MockDevice> devices = [
    MockDevice(
      name: 'Стельове світло',
      room: 'Вітальня',
      status: 'Яскравість 80%',
      icon: Icons.lightbulb_outline,
      isOn: true,
    ),
    MockDevice(
      name: 'Термостат',
      room: 'Вітальня',
      status: '22.5 °C',
      icon: Icons.thermostat,
      isOn: true,
    ),
    MockDevice(
      name: 'Датчик вологості',
      room: 'Ванна',
      status: '58%',
      icon: Icons.water_drop_outlined,
      isOn: true,
    ),
    MockDevice(
      name: 'Розумна розетка',
      room: 'Кухня',
      status: 'Вимкнено',
      icon: Icons.power_outlined,
      isOn: false,
    ),
    MockDevice(
      name: 'Датчик руху',
      room: 'Коридор',
      status: 'Рух не виявлено',
      icon: Icons.sensors,
      isOn: true,
    ),
    MockDevice(
      name: 'Кондиціонер',
      room: 'Спальня',
      status: 'Вимкнено',
      icon: Icons.ac_unit,
      isOn: false,
    ),
  ];
}
