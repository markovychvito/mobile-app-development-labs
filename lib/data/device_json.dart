import 'package:my_project/domain/models/device.dart';

/// Перетворення [Device] <-> JSON. Живе в шарі data, бо формат
/// зберігання — деталь реалізації, про яку домен знати не повинен.
extension DeviceJson on Device {
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'type': type.name,
    'isOn': isOn,
  };
}

Device deviceFromJson(Map<String, dynamic> json) {
  return Device(
    id: json['id'] as String,
    name: json['name'] as String,
    location: json['location'] as String,
    type: DeviceType.values.byName(json['type'] as String),
    isOn: json['isOn'] as bool,
  );
}
