import 'just_validator.dart';

/// IsTrueValidator checks if a boolean value is true.
class IsTrueValidator implements JustValidator<bool> {
  const IsTrueValidator({this.customErrorMessage});

  @override
  final String? customErrorMessage;

  @override
  String get defaultErrorMessage => 'Required';

  @override
  String? validate(bool? value) {
    if (value != true) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    return null;
  }
}
