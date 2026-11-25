import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/data/shared_prefs_auth_repository.dart';
import 'package:my_project/domain/exceptions/app_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;
  late SharedPrefsAuthRepository repository;

  Future<void> registerAndrii() {
    return repository.register(
      name: 'Андрій Шевченко',
      email: 'andrii@homelab.ua',
      password: 'smart123',
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repository = SharedPrefsAuthRepository(prefs, latency: Duration.zero);
  });

  test('register creates a user and opens a session', () async {
    await registerAndrii();
    final user = await repository.currentUser();
    expect(user?.name, 'Андрій Шевченко');
    expect(user?.firstName, 'Андрій');
  });

  test('email is normalized (trim + lower case)', () async {
    await repository.register(
      name: 'Олена',
      email: '  Olena@Mail.COM ',
      password: 'smart123',
    );
    expect((await repository.currentUser())?.email, 'olena@mail.com');
  });

  test('password is stored as a salted hash, not plain text', () async {
    await registerAndrii();
    final raw = prefs.getString('auth.users')!;
    expect(raw, isNot(contains('smart123')));
    expect(raw, contains('passwordHash'));
  });

  test('duplicate email is rejected', () async {
    await registerAndrii();
    expect(registerAndrii, throwsA(isA<AuthException>()));
  });

  test('invalid data is rejected even without UI validation', () {
    expect(
      () => repository.register(name: 'A1', email: 'bad', password: '1'),
      throwsA(isA<AuthException>()),
    );
  });

  test('login succeeds with correct credentials', () async {
    await registerAndrii();
    await repository.logout();
    final user = await repository.login(
      email: 'ANDRII@homelab.ua',
      password: 'smart123',
    );
    expect(user.email, 'andrii@homelab.ua');
  });

  test('login fails with the same message for wrong password/email', () async {
    await registerAndrii();
    await repository.logout();

    Future<String> messageFor(String email, String password) async {
      try {
        await repository.login(email: email, password: password);
        return 'no error';
      } on AuthException catch (e) {
        return e.message;
      }
    }

    final wrongPassword = await messageFor('andrii@homelab.ua', 'wrong123');
    final unknownEmail = await messageFor('nobody@homelab.ua', 'smart123');
    expect(wrongPassword, 'Невірна пошта або пароль');
    expect(unknownEmail, wrongPassword);
    expect(await repository.currentUser(), isNull);
  });

  test('session survives an app restart (new repository instance)', () async {
    await registerAndrii();
    final restarted = SharedPrefsAuthRepository(prefs, latency: Duration.zero);
    expect((await restarted.currentUser())?.email, 'andrii@homelab.ua');
  });

  test('logout clears the session', () async {
    await registerAndrii();
    await repository.logout();
    expect(await repository.currentUser(), isNull);
  });

  test('updateName validates and persists the new name', () async {
    await registerAndrii();
    final updated = await repository.updateName('Андрій Коваль');
    expect(updated.name, 'Андрій Коваль');
    expect((await repository.currentUser())?.name, 'Андрій Коваль');
    expect(() => repository.updateName('R2D2'), throwsA(isA<AuthException>()));
  });
}
