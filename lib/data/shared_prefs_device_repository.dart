import 'dart:convert';
import 'dart:math';

import 'package:my_project/data/device_json.dart';
import 'package:my_project/data/simulated_latency.dart';
import 'package:my_project/domain/exceptions/app_exception.dart';
import 'package:my_project/domain/models/device.dart';
import 'package:my_project/domain/repositories/device_repository.dart';
import 'package:my_project/domain/validation/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [IDeviceRepository] поверх SharedPreferences.
///
/// Пристрої кожного користувача лежать окремим JSON-списком під ключем
/// `devices.<ownerId>`, тож користувачі не бачать чужих пристроїв.
class SharedPrefsDeviceRepository implements IDeviceRepository {
  SharedPrefsDeviceRepository(
    this._prefs, {
    this.latency = const Duration(milliseconds: 300),
  });

  final SharedPreferences _prefs;
  final Duration latency;
  final Random _random = Random();

  @override
  Future<List<Device>> fetchAll(String ownerId) async {
    await simulateLatency(latency);
    return _read(ownerId);
  }

  @override
  Future<Device> add(
    String ownerId, {
    required String name,
    required String location,
    required DeviceType type,
  }) async {
    await simulateLatency(latency);
    _validate(name, location);
    final device = Device(
      id: _newId(),
      name: name.trim(),
      location: location.trim(),
      type: type,
      isOn: false,
    );
    await _write(ownerId, [..._read(ownerId), device]);
    return device;
  }

  @override
  Future<Device> update(String ownerId, Device device) async {
    await simulateLatency(latency);
    _validate(device.name, device.location);
    final devices = _read(ownerId);
    if (!devices.any((item) => item.id == device.id)) {
      throw const AppException('Пристрій не знайдено');
    }
    await _write(ownerId, [
      for (final item in devices)
        if (item.id == device.id) device else item,
    ]);
    return device;
  }

  @override
  Future<void> delete(String ownerId, String deviceId) async {
    await simulateLatency(latency);
    final devices = _read(ownerId);
    await _write(ownerId, [
      for (final item in devices)
        if (item.id != deviceId) item,
    ]);
  }

  void _validate(String name, String location) {
    final error = Validators.deviceName(name) ?? Validators.location(location);
    if (error != null) throw AppException(error);
  }

  /// Час + випадковий суфікс: два швидкі додавання не дадуть однаковий id.
  String _newId() {
    final time = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final salt = _random.nextInt(0x7fffffff).toRadixString(36);
    return '$time-$salt';
  }

  String _key(String ownerId) => 'devices.$ownerId';

  List<Device> _read(String ownerId) {
    final raw = _prefs.getString(_key(ownerId));
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return [
      for (final item in list) deviceFromJson(item as Map<String, dynamic>),
    ];
  }

  Future<void> _write(String ownerId, List<Device> devices) {
    final json = jsonEncode([for (final device in devices) device.toJson()]);
    return _prefs.setString(_key(ownerId), json);
  }
}
