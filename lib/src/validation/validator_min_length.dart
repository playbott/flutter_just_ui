import 'just_validator.dart';

/// MinLengthValidator checks the minimum length of a string.
class MinLengthValidator implements JustValidator<String> {
  MinLengthValidator(this.minLength, {this.customErrorMessage})
    : assert(minLength > 0);

  @override
  String? customErrorMessage;

  final int minLength;

  @override
  String get defaultErrorMessage => 'Minimum length: $minLength characters';

  @override
  String? validate(String? value) {
    if (value == null || value.length < minLength) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    return null;
  }
}
