/// Очікувана помилка бізнес-логіки з повідомленням для користувача.
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Помилка реєстрації чи входу (зайнята пошта, невірний пароль тощо).
class AuthException extends AppException {
  const AuthException(super.message);
}
