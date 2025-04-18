import 'just_validator.dart';

/// MaxLengthValidator checks the maximum length of a string.
class MaxLengthValidator implements JustValidator<String> {
  MaxLengthValidator(this.maxLength, {this.customErrorMessage})
    : assert(maxLength > 0);

  @override
  final String? customErrorMessage;

  /// The maximum length of the string.
  final int maxLength;

  @override
  String get defaultErrorMessage => 'Maximum length: $maxLength characters';

  @override
  String? validate(String? value) {
    if (value == null || value.length > maxLength) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    return null;
  }
}
