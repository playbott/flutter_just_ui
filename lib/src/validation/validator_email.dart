import 'just_validator.dart';

/// EmailValidator checks if a string is a valid email address.
class EmailValidator implements JustValidator<String> {
  EmailValidator({this.customErrorMessage});

  @override
  final String? customErrorMessage;

  @override
  String get defaultErrorMessage => 'Enter a valid email address';

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    return null;
  }
}
