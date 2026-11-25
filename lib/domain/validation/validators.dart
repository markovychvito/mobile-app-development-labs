/// Бізнес-правила валідації. Кожен метод повертає текст помилки
/// або null, якщо значення коректне, тому його можна напряму
/// передати у `TextFormField.validator`.
abstract final class Validators {
  static const int minPasswordLength = 8;

  static final RegExp _email = RegExp(
    r'^[\w.+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$',
  );
  static final RegExp _name = RegExp(r"^[A-Za-zА-Яа-яІіЇїЄєҐґ'ʼ\- ]+$");
  static final RegExp _digit = RegExp(r'\d');
  static final RegExp _letter = RegExp('[A-Za-zА-Яа-яІіЇїЄєҐґ]');

  static String? name(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return "Введіть ім'я";
    if (_digit.hasMatch(name)) return "Ім'я не може містити цифри";
    if (!_name.hasMatch(name)) {
      return "Ім'я може містити лише літери, пробіл, дефіс та апостроф";
    }
    if (name.length < 2) return "Ім'я занадто коротке";
    if (name.length > 50) return "Ім'я занадто довге (макс. 50 символів)";
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Введіть електронну пошту';
    if (!email.contains('@')) return 'Пошта повинна містити символ @';
    if (!_email.hasMatch(email)) {
      return 'Невірний формат пошти, напр. name@example.com';
    }
    return null;
  }

  static String? password(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Введіть пароль';
    if (password.length < minPasswordLength) {
      return 'Пароль має містити щонайменше $minPasswordLength символів';
    }
    if (password.contains(' ')) return 'Пароль не може містити пробіли';
    if (!_letter.hasMatch(password) || !_digit.hasMatch(password)) {
      return 'Пароль має містити хоча б одну літеру та одну цифру';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Повторіть пароль';
    if (value != original) return 'Паролі не збігаються';
    return null;
  }

  /// На вході складність пароля не перевіряємо: лише що поле не порожнє.
  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'Введіть пароль';
    return null;
  }

  static String? deviceName(String? value) => _shortText(value, 'назву');

  static String? location(String? value) => _shortText(value, 'розташування');

  static String? _shortText(String? value, String what) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Вкажіть $what';
    if (text.length < 2) return 'Щонайменше 2 символи';
    if (text.length > 30) return 'Максимум 30 символів';
    return null;
  }
}
