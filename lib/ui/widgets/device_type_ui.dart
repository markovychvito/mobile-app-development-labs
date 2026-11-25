import 'package:material_ui/material_ui.dart';
import 'package:my_project/domain/models/device.dart';

/// Як тип пристрою виглядає на UI. Іконки й підписи — справа UI,
/// тому вони тут, а не в доменній моделі.
extension DeviceTypeUi on DeviceType {
  String get label => switch (this) {
    DeviceType.raspberryPi => 'Raspberry Pi',
    DeviceType.miniPc => 'Міні-ПК / сервер',
    DeviceType.nas => 'NAS (сховище)',
    DeviceType.router => 'Роутер / світч',
    DeviceType.ups => 'ДБЖ (UPS)',
    DeviceType.sensor => 'Датчик стійки',
  };

  IconData get icon => switch (this) {
    DeviceType.raspberryPi => Icons.developer_board,
    DeviceType.miniPc => Icons.computer,
    DeviceType.nas => Icons.storage,
    DeviceType.router => Icons.router_outlined,
    DeviceType.ups => Icons.battery_charging_full,
    DeviceType.sensor => Icons.thermostat,
  };
}
