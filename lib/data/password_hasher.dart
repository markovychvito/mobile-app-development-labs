import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Хешує паролі, щоб у сховищі ніколи не лежав відкритий текст.
///
/// Сіль (випадкові байти) унікальна для кожного користувача: однакові
/// паролі дають різні хеші. Для навчального локального сховища SHA-256
/// достатньо; на сервері варто брати повільні алгоритми (bcrypt, Argon2).
class PasswordHasher {
  const PasswordHasher();

  String generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  String hash(String password, String salt) {
    return sha256.convert(utf8.encode('$salt:$password')).toString();
  }
}
