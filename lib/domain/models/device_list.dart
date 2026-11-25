import 'package:my_project/domain/models/device.dart';

/// Незмінні операції над списком: кожна повертає НОВИЙ список,
/// старий не змінюється. Це те, що потрібно для setState.
extension DeviceList on List<Device> {
  List<Device> replacing(Device updated) => [
    for (final device in this)
      if (device.id == updated.id) updated else device,
  ];

  List<Device> without(String deviceId) => [
    for (final device in this)
      if (device.id != deviceId) device,
  ];
}
