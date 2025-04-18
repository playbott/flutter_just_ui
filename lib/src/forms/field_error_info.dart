import '/src/validation/validation_error.dart';

class FieldErrorInfo {
  /// Field label (example: Email, Name, etc.) if it is provided.
  final String? label;

  /// List of errors for the field.
  final List<ValidationError> errors;

  FieldErrorInfo({required this.errors, this.label});
}
