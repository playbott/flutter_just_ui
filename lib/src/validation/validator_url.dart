import 'just_validator.dart';

class UrlValidator implements JustValidator<String> {
  UrlValidator({this.customErrorMessage});

  @override
  final String? customErrorMessage;

  @override
  String get defaultErrorMessage => 'Enter a valid URL';

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    final urlRegex = RegExp(
      r'^(https?://)?(www\.)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:[0-9]+)?(/\S*)?$',
      caseSensitive: false,
    );
    if (!urlRegex.hasMatch(value)) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    return null;
  }
}
