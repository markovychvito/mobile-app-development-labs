import 'package:my_project/domain/models/device.dart';

/// Що користувач обрав у формі пристрою: зберегти або видалити.
///
/// `sealed` дозволяє компілятору перевірити, що `switch` обробляє
/// всі варіанти (exhaustiveness check).
sealed class DeviceFormResult {
  const DeviceFormResult();
}

final class DeviceFormSaved extends DeviceFormResult {
  const DeviceFormSaved({
    required this.name,
    required this.location,
    required this.type,
  });

  final String name;
  final String location;
  final DeviceType type;
}

final class DeviceFormDeleted extends DeviceFormResult {
  const DeviceFormDeleted();
}
