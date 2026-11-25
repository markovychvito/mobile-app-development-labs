import 'package:my_project/domain/models/user.dart';

/// Запис користувача у сховищі (DTO). На відміну від доменного [User],
/// містить хеш пароля та сіль, тому за межі шару data не виходить.
class UserRecord {
  const UserRecord({
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.salt,
    required this.createdAt,
  });

  factory UserRecord.fromJson(Map<String, dynamic> json) {
    return UserRecord(
      name: json['name'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String,
      salt: json['salt'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String name;
  final String email;
  final String passwordHash;
  final String salt;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'passwordHash': passwordHash,
    'salt': salt,
    'createdAt': createdAt.toIso8601String(),
  };

  User toDomain() => User(name: name, email: email, createdAt: createdAt);

  UserRecord copyWith({String? name}) {
    return UserRecord(
      name: name ?? this.name,
      email: email,
      passwordHash: passwordHash,
      salt: salt,
      createdAt: createdAt,
    );
  }
}
