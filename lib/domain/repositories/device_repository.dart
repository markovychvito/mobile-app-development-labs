import 'package:my_project/domain/models/device.dart';

/// Контракт CRUD-операцій над пристроями конкретного власника.
abstract interface class IDeviceRepository {
  /// Read: усі пристрої власника.
  Future<List<Device>> fetchAll(String ownerId);

  /// Create: новий пристрій (вимкнений), id генерує сховище.
  Future<Device> add(
    String ownerId, {
    required String name,
    required String location,
    required DeviceType type,
  });

  /// Update: зберігає змінений пристрій і повертає його.
  Future<Device> update(String ownerId, Device device);

  /// Delete: видаляє пристрій за id.
  Future<void> delete(String ownerId, String deviceId);
}
