import 'just_validator.dart';

/// Stores the validation result of a single field.
class ValidationError {
  /// The ID of the field where the error occurred.
  final String fieldId;

  /// The ID of the validator (e.g., 'required', 'minLength')
  final JustValidator validator;

  /// The error message for the user.
  final String message;

  const ValidationError({
    required this.fieldId,
    required this.validator,
    required this.message,
  });

  @override
  String toString() =>
      'ValidationError(fieldId: $fieldId, validatorId: $validator, message: "$message")';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationError &&
          runtimeType == other.runtimeType &&
          fieldId == other.fieldId &&
          validator == other.validator &&
          message == other.message;

  @override
  int get hashCode => fieldId.hashCode ^ validator.hashCode ^ message.hashCode;
}
