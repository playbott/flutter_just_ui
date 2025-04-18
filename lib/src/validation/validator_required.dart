import '../../just_ui.dart';
import 'just_validator.dart';

/// RequiredValidator checks if a string field is not empty.
class RequiredValidator implements JustValidator<String> {
  RequiredValidator({this.customErrorMessage});

  @override
  final String? customErrorMessage;

  @override
  String get defaultErrorMessage => 'This field is required';

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    return null;
  }
}
