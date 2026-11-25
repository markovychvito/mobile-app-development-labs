import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/domain/validation/validators.dart';

void main() {
  group('Validators.name', () {
    test('accepts Ukrainian and Latin names', () {
      expect(Validators.name('Андрій Шевченко'), isNull);
      expect(Validators.name("Мар'яна"), isNull);
      expect(Validators.name('John Smith-Doe'), isNull);
    });

    test('rejects empty, digits, symbols and too short names', () {
      expect(Validators.name(''), isNotNull);
      expect(Validators.name('   '), isNotNull);
      expect(Validators.name('Andrii2'), contains('цифри'));
      expect(Validators.name('Andrii!'), isNotNull);
      expect(Validators.name('A'), isNotNull);
    });
  });

  group('Validators.email', () {
    test('accepts valid emails', () {
      expect(Validators.email('name@example.com'), isNull);
      expect(Validators.email('first.last+iot@mail.co.ua'), isNull);
    });

    test('rejects emails without @ or domain', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('name.example.com'), contains('@'));
      expect(Validators.email('name@'), isNotNull);
      expect(Validators.email('name@example'), isNotNull);
      expect(Validators.email('name@@example.com'), isNotNull);
    });
  });

  group('Validators.password', () {
    test('accepts 8+ chars with a letter and a digit', () {
      expect(Validators.password('smart123'), isNull);
    });

    test('rejects short, letter-only, digit-only and spaced passwords', () {
      expect(Validators.password('abc123'), contains('8'));
      expect(Validators.password('abcdefgh'), isNotNull);
      expect(Validators.password('12345678'), isNotNull);
      expect(Validators.password('smart 123'), isNotNull);
    });
  });

  test('confirmPassword requires the same value', () {
    expect(Validators.confirmPassword('smart123', 'smart123'), isNull);
    expect(Validators.confirmPassword('smart124', 'smart123'), isNotNull);
    expect(Validators.confirmPassword('', 'smart123'), isNotNull);
  });

  test('deviceName and location require 2..30 chars', () {
    expect(Validators.deviceName('mini-pc'), isNull);
    expect(Validators.deviceName(' '), isNotNull);
    expect(Validators.location('A'), isNotNull);
    expect(Validators.location('x' * 31), isNotNull);
  });
}
