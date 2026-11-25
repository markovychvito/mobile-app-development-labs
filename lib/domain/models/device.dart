/// Типи пристроїв домашньої лабораторії (HomeLab).
enum DeviceType { raspberryPi, miniPc, nas, router, ups, sensor }

/// Пристрій домашньої лабораторії: сервер, NAS, роутер, ДБЖ, датчик
/// (доменна модель, immutable).
class Device {
  const Device({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    required this.isOn,
  });

  final String id;
  final String name;
  final String location;
  final DeviceType type;
  final bool isOn;

  Device copyWith({
    String? name,
    String? location,
    DeviceType? type,
    bool? isOn,
  }) {
    return Device(
      id: id,
      name: name ?? this.name,
      location: location ?? this.location,
      type: type ?? this.type,
      isOn: isOn ?? this.isOn,
    );
  }
}
