import 'just_validator.dart';

class LettersOnlyValidator implements JustValidator<String> {
  LettersOnlyValidator({this.customErrorMessage});

  @override
  final String? customErrorMessage;

  @override
  String get defaultErrorMessage => 'Only letters are allowed';

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    final lettersRegex = RegExp(r'^[a-zA-Z]+$');
    if (!lettersRegex.hasMatch(value)) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    return null;
  }
}
