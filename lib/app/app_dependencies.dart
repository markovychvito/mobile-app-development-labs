import 'package:my_project/domain/repositories/auth_repository.dart';
import 'package:my_project/domain/repositories/device_repository.dart';

/// Набір залежностей застосунку. Типи полів — абстракції, тому
/// екрани не знають, яка саме реалізація сховища під ними.
class AppDependencies {
  const AppDependencies({
    required this.authRepository,
    required this.deviceRepository,
  });

  final IAuthRepository authRepository;
  final IDeviceRepository deviceRepository;
}
