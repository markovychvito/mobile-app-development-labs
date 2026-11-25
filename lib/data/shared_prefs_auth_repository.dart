import 'dart:convert';

import 'package:my_project/data/password_hasher.dart';
import 'package:my_project/data/simulated_latency.dart';
import 'package:my_project/data/user_record.dart';
import 'package:my_project/domain/exceptions/app_exception.dart';
import 'package:my_project/domain/models/user.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';
import 'package:my_project/domain/validation/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [IAuthRepository] поверх SharedPreferences.
///
/// Користувачі зберігаються JSON-списком під ключем [_usersKey],
/// пошта поточної сесії — під [_sessionKey]. Завдяки сесії після
/// перезапуску застосунку користувач лишається залогіненим.
class SharedPrefsAuthRepository implements IAuthRepository {
  SharedPrefsAuthRepository(
    this._prefs, {
    this.latency = const Duration(milliseconds: 400),
    this.hasher = const PasswordHasher(),
  });

  static const String _usersKey = 'auth.users';
  static const String _sessionKey = 'auth.session_email';
  static const String _invalidCredentials = 'Невірна пошта або пароль';

  final SharedPreferences _prefs;
  final PasswordHasher hasher;

  /// Імітує затримку мережі, щоб UI вже зараз коректно показував
  /// індикатори завантаження (як буде з REST API).
  final Duration latency;

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await simulateLatency(latency);
    // Правила перевіряємо і тут: репозиторій не довіряє UI наосліп.
    final error =
        Validators.name(name) ??
        Validators.email(email) ??
        Validators.password(password);
    if (error != null) throw AuthException(error);

    final normalizedEmail = _normalize(email);
    final users = _readUsers();
    if (_find(users, normalizedEmail) != null) {
      throw const AuthException('Користувач з такою поштою вже існує');
    }

    final salt = hasher.generateSalt();
    final record = UserRecord(
      name: name.trim(),
      email: normalizedEmail,
      passwordHash: hasher.hash(password, salt),
      salt: salt,
      createdAt: DateTime.now(),
    );
    await _writeUsers([...users, record]);
    await _prefs.setString(_sessionKey, normalizedEmail);
    return record.toDomain();
  }

  @override
  Future<User> login({required String email, required String password}) async {
    await simulateLatency(latency);
    final record = _find(_readUsers(), _normalize(email));
    // Одне повідомлення для обох випадків: не підказуємо зловмиснику,
    // чи існує така пошта.
    if (record == null ||
        hasher.hash(password, record.salt) != record.passwordHash) {
      throw const AuthException(_invalidCredentials);
    }
    await _prefs.setString(_sessionKey, record.email);
    return record.toDomain();
  }

  @override
  Future<User?> currentUser() async {
    final email = _prefs.getString(_sessionKey);
    if (email == null) return null;
    return _find(_readUsers(), email)?.toDomain();
  }

  @override
  Future<User> updateName(String name) async {
    await simulateLatency(latency);
    final error = Validators.name(name);
    if (error != null) throw AuthException(error);

    final email = _prefs.getString(_sessionKey);
    final users = _readUsers();
    final current = email == null ? null : _find(users, email);
    if (current == null) throw const AuthException('Сесія завершилась');

    final updated = current.copyWith(name: name.trim());
    await _writeUsers([
      for (final user in users)
        if (user.email == email) updated else user,
    ]);
    return updated.toDomain();
  }

  @override
  Future<void> logout() => _prefs.remove(_sessionKey);

  String _normalize(String email) => email.trim().toLowerCase();

  UserRecord? _find(List<UserRecord> users, String email) {
    return users.where((user) => user.email == email).firstOrNull;
  }

  List<UserRecord> _readUsers() {
    final raw = _prefs.getString(_usersKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return [
      for (final item in list)
        UserRecord.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<void> _writeUsers(List<UserRecord> users) {
    final json = jsonEncode([for (final user in users) user.toJson()]);
    return _prefs.setString(_usersKey, json);
  }
}
