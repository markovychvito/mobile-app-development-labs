/// Користувач застосунку (доменна модель).
///
/// Незмінний (immutable): усі поля final, зміни робляться через [copyWith],
/// який повертає новий об'єкт. Пароля тут немає навмисно: UI не повинен
/// мати до нього доступу, він живе лише в шарі data.
class User {
  const User({
    required this.name,
    required this.email,
    required this.createdAt,
  });

  final String name;
  final String email;
  final DateTime createdAt;

  String get firstName => name.trim().split(RegExp(r'\s+')).first;

  User copyWith({String? name}) {
    return User(name: name ?? this.name, email: email, createdAt: createdAt);
  }
}
