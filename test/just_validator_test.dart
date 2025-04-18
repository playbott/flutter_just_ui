import 'package:flutter_test/flutter_test.dart';
import 'package:just_ui/just_validation.dart';

void main() {
  group('IpAddressValidator', () {
    final validator = IpAddressValidator();
    final customValidator = IpAddressValidator(
      customErrorMessage: 'Invalid IP!',
    );

    test('valid IPv4 address', () {
      expect(validator.validate('192.168.1.1'), isNull);
      expect(validator.validate('10.0.0.255'), isNull);
      expect(validator.validate('0.0.0.0'), isNull);
    });

    test('invalid IPv4 address', () {
      expect(
        validator.validate('256.1.2.3'),
        equals('Enter a valid IPv4 address'),
      );
      expect(
        validator.validate('056.01.02.03'),
        equals('Enter a valid IPv4 address'),
      );
      expect(validator.validate('1.2.3'), equals('Enter a valid IPv4 address'));
      expect(
        validator.validate('1.2.3.4.5'),
        equals('Enter a valid IPv4 address'),
      );
      expect(
        validator.validate('abc.def.ghi.jkl'),
        equals('Enter a valid IPv4 address'),
      );
    });

    test('null or empty input', () {
      expect(validator.validate(null), equals('Enter a valid IPv4 address'));
      expect(validator.validate(''), equals('Enter a valid IPv4 address'));
    });

    test('custom error message', () {
      expect(customValidator.validate('256.1.2.3'), equals('Invalid IP!'));
    });
  });

  group('EmailValidator', () {
    final validator = EmailValidator();
    final customValidator = EmailValidator(
      customErrorMessage: 'Invalid email!',
    );

    test('valid email', () {
      expect(validator.validate('test@example.com'), isNull);
      expect(validator.validate('user.name@domain.co.uk'), isNull);
      expect(validator.validate('user+label@sub.domain.com'), isNull);
    });

    test('invalid email', () {
      expect(
        validator.validate('test@'),
        equals('Enter a valid email address'),
      );
      expect(
        validator.validate('test.example.com'),
        equals('Enter a valid email address'),
      );
      expect(
        validator.validate('test@domain'),
        equals('Enter a valid email address'),
      );
      expect(
        validator.validate('test@.com'),
        equals('Enter a valid email address'),
      );
    });

    test('null or empty input', () {
      expect(validator.validate(null), equals('Enter a valid email address'));
      expect(validator.validate(''), equals('Enter a valid email address'));
    });

    test('custom error message', () {
      expect(customValidator.validate('test@'), equals('Invalid email!'));
    });
  });

  group('UrlValidator', () {
    final validator = UrlValidator();
    final customValidator = UrlValidator(customErrorMessage: 'Invalid URL!');

    test('valid URL', () {
      expect(validator.validate('https://example.com'), isNull);
      expect(validator.validate('http://sub.domain.com/path'), isNull);
      expect(validator.validate('example.com'), isNull);
      expect(
        validator.validate('https://example.com:8080/path?query=1'),
        isNull,
      );
    });

    test('invalid URL', () {
      expect(validator.validate('http://'), equals('Enter a valid URL'));
      expect(validator.validate('example'), equals('Enter a valid URL'));
      expect(
        validator.validate('ftp://example.com'),
        equals('Enter a valid URL'),
      );
      expect(
        validator.validate('https://example..com'),
        equals('Enter a valid URL'),
      );
    });

    test('null or empty input', () {
      expect(validator.validate(null), equals('Enter a valid URL'));
      expect(validator.validate(''), equals('Enter a valid URL'));
    });

    test('custom error message', () {
      expect(customValidator.validate('http://'), equals('Invalid URL!'));
    });
  });

  group('LettersOnlyValidator', () {
    final validator = LettersOnlyValidator();
    final customValidator = LettersOnlyValidator(
      customErrorMessage: 'Only letters!',
    );

    test('valid letters', () {
      expect(validator.validate('Hello'), isNull);
      expect(validator.validate('ABCxyz'), isNull);
    });

    test('invalid letters', () {
      expect(
        validator.validate('Hello123'),
        equals('Only letters are allowed'),
      );
      expect(validator.validate('Hello!'), equals('Only letters are allowed'));
      expect(validator.validate('123'), equals('Only letters are allowed'));
      expect(
        validator.validate('Hello World'),
        equals('Only letters are allowed'),
      );
    });

    test('null or empty input', () {
      expect(validator.validate(null), equals('Only letters are allowed'));
      expect(validator.validate(''), equals('Only letters are allowed'));
    });

    test('custom error message', () {
      expect(customValidator.validate('Hello123'), equals('Only letters!'));
    });
  });

  group('NumbersOnlyValidator', () {
    final validator = NumbersOnlyValidator();
    final customValidator = NumbersOnlyValidator(
      customErrorMessage: 'Only numbers!',
    );

    test('valid numbers', () {
      expect(validator.validate('123'), isNull);
      expect(validator.validate('000'), isNull);
    });

    test('invalid numbers', () {
      expect(validator.validate('123abc'), equals('Only numbers are allowed'));
      expect(validator.validate('12.34'), equals('Only numbers are allowed'));
      expect(validator.validate('123!'), equals('Only numbers are allowed'));
      expect(validator.validate('abc'), equals('Only numbers are allowed'));
    });

    test('null or empty input', () {
      expect(validator.validate(null), equals('Only numbers are allowed'));
      expect(validator.validate(''), equals('Only numbers are allowed'));
    });

    test('custom error message', () {
      expect(customValidator.validate('123abc'), equals('Only numbers!'));
    });
  });

  group('LettersAndNumbersValidator', () {
    final validator = LettersAndNumbersValidator();
    final customValidator = LettersAndNumbersValidator(
      customErrorMessage: 'Only letters and numbers!',
    );

    test('valid alphanumeric', () {
      expect(validator.validate('Hello123'), isNull);
      expect(validator.validate('ABC789xyz'), isNull);
    });

    test('invalid alphanumeric', () {
      expect(
        validator.validate('Hello!'),
        equals('Only letters and numbers are allowed'),
      );
      expect(
        validator.validate('Hello 123'),
        equals('Only letters and numbers are allowed'),
      );
      expect(
        validator.validate('123!@#'),
        equals('Only letters and numbers are allowed'),
      );
      expect(
        validator.validate('Hello_123'),
        equals('Only letters and numbers are allowed'),
      );
    });

    test('null or empty input', () {
      expect(
        validator.validate(null),
        equals('Only letters and numbers are allowed'),
      );
      expect(
        validator.validate(''),
        equals('Only letters and numbers are allowed'),
      );
    });

    test('custom error message', () {
      expect(
        customValidator.validate('Hello!'),
        equals('Only letters and numbers!'),
      );
    });
  });
}
