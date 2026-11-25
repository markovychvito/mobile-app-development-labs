import 'package:my_project/domain/models/user.dart';

/// Контракт авторизації. UI знає лише про цей інтерфейс,
/// а не про те, де саме зберігаються користувачі.
///
/// Сьогодні реалізація — SharedPreferences, завтра — REST API:
/// UI при цьому не зміниться, достатньо підмінити реалізацію в main.dart.
abstract interface class IAuthRepository {
  /// Створює користувача і одразу відкриває для нього сесію.
  /// Кидає AuthException, якщо дані невалідні або пошта зайнята.
  Future<User> register({
    required String name,
    required String email,
    required String password,
  });

  /// Кидає AuthException, якщо пошта чи пароль невірні.
  Future<User> login({required String email, required String password});

  /// Користувач поточної сесії або null, якщо ніхто не увійшов.
  Future<User?> currentUser();

  Future<User> updateName(String name);

  Future<void> logout();
}
