import 'package:flutter_test/flutter_test.dart';
import 'package:gst_billing_system/services/auth_service.dart';

void main() {
  group('AuthService Validators Unit Tests', () {
    group('Email Validation', () {
      test('valid email returns null', () {
        expect(AuthService.validateEmail('user@example.com'), isNull);
        expect(AuthService.validateEmail('test.dev@sub.domain.org'), isNull);
        expect(
          AuthService.validateEmail('firstname+lastname@company.co'),
          isNull,
        );
      });

      test('empty or null email returns error', () {
        expect(AuthService.validateEmail(null), isNotNull);
        expect(AuthService.validateEmail(''), isNotNull);
        expect(AuthService.validateEmail('   '), isNotNull);
      });

      test('malformed email returns error', () {
        expect(AuthService.validateEmail('userexample.com'), isNotNull);
        expect(AuthService.validateEmail('user@'), isNotNull);
        expect(AuthService.validateEmail('user@domain'), isNotNull);
        expect(AuthService.validateEmail('user@domain.'), isNotNull);
      });
    });

    group('Password Validation', () {
      test('valid password (>=6 chars) returns null', () {
        expect(AuthService.validatePassword('123456'), isNull);
        expect(AuthService.validatePassword('StrongP@ss123'), isNull);
      });

      test('empty or null password returns error', () {
        expect(AuthService.validatePassword(null), isNotNull);
        expect(AuthService.validatePassword(''), isNotNull);
      });

      test('short password (<6 chars) returns error', () {
        expect(AuthService.validatePassword('12345'), isNotNull);
        expect(AuthService.validatePassword('abc'), isNotNull);
      });
    });

    group('Confirm Password Validation', () {
      test('matching confirm password returns null', () {
        expect(
          AuthService.validateConfirmPassword('MySecret123', 'MySecret123'),
          isNull,
        );
      });

      test('mismatched confirm password returns error', () {
        expect(
          AuthService.validateConfirmPassword('WrongSecret', 'MySecret123'),
          isNotNull,
        );
      });

      test('empty confirm password returns error', () {
        expect(
          AuthService.validateConfirmPassword('', 'MySecret123'),
          isNotNull,
        );
      });
    });

    group('Full Name Validation', () {
      test('valid full name returns null', () {
        expect(AuthService.validateFullName('Ramesh Kumar'), isNull);
        expect(AuthService.validateFullName('Om'), isNull);
      });

      test('empty or whitespace-only name returns error', () {
        expect(AuthService.validateFullName(null), isNotNull);
        expect(AuthService.validateFullName(''), isNotNull);
        expect(AuthService.validateFullName('   '), isNotNull);
      });

      test('single character name returns error', () {
        expect(AuthService.validateFullName('A'), isNotNull);
      });
    });
  });
}
