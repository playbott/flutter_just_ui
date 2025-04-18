/// Base class for all validators in the JustForm system.
abstract class JustValidator<T> {
  /// The default error message for this validator.
  /// Can be overridden when creating an instance of the validator.
  String get defaultErrorMessage;

  /// The custom error message for this validator.
  String? get customErrorMessage;

  /// Takes the current value of the field
  /// Returns a string with the error message if the value is invalid, otherwise `null`.
  String? validate(T? value);
}
