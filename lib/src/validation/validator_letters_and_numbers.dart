import 'just_validator.dart';

class LettersAndNumbersValidator implements JustValidator<String> {
  LettersAndNumbersValidator({this.customErrorMessage});

  @override
  final String? customErrorMessage;

  @override
  String get defaultErrorMessage => 'Only letters and numbers are allowed';

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!alphanumericRegex.hasMatch(value)) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    return null;
  }
}
