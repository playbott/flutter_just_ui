import 'just_validator.dart';
import 'dart:core';

/// IpAddressValidator checks if a string is a valid IPv4 address.
class IpAddressValidator implements JustValidator<String> {
  IpAddressValidator({this.customErrorMessage});

  @override
  final String? customErrorMessage;

  @override
  String get defaultErrorMessage => 'Enter a valid IPv4 address';

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    final ipRegex = RegExp(
      r'^'
      r'(?:(?:0|[1-9]\d?|1\d{2}|2[0-4]\d|25[0-5])\.){3}'
      r'(?:0|[1-9]\d?|1\d{2}|2[0-4]\d|25[0-5])'
      r'$',
    );
    if (!ipRegex.hasMatch(value)) {
      return customErrorMessage ?? defaultErrorMessage;
    }
    return null;
  }
}
