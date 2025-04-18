import 'just_validator.dart';

class NumbersOnlyValidator implements JustValidator<String> {
  NumbersOnlyValidator({this.customErrorMessage});

  @override
  final String? customErrorMessage;

  @override
  String get defaultErrorMessage => 'Only numbers are allowed';

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    final numbersRegex = RegExp(r'^\d+$');
    if (!numbersRegex.hasMatch(value)) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    return null;
  }
}
