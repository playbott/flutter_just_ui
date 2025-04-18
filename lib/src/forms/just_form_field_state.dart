import 'package:just_ui/src/validation/just_validator.dart';
import 'package:just_ui/src/validation/validation_error.dart';

/// Interface for all JustForm field states.
/// Defines the contract between JustFormController and the fields.
abstract class JustFormFieldState<T> {
  /// The unique ID of the field within the form.
  String get fieldId;

  /// The list of validators for the field.
  List<JustValidator<T>> get validators;

  ///  Hide error under the field
  bool get hideError;

  /// Returns the current value of the field.
  T? get currentValue;

  /// Validates the field using its `validators`.
  /// Returns a list of detailed errors [ValidationError].
  List<ValidationError> validateField();

  /// Resets the field to its initial value and clear errors.
  void resetField();

  /// Saves the current value of the field.
  /// Can be used for calling onSaved callback or other actions.
  void saveField();

  /// Updates the visual representation of the error for the field.
  /// Called by the controller after general validation.
  /// [errorText] - the error text to display (or null to clear).
  void setFieldError(String? errorText);
}
