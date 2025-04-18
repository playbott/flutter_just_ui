import 'package:flutter/foundation.dart';
import 'field_error_info.dart';
import 'just_form_field_state.dart';

/// Controller for managing the state of `JustForm`.
/// Provides API for validation, saving, resetting the form
/// and accessing values and errors of form fields by ID.
class JustFormController extends ChangeNotifier {
  /// Stores references to the states of registered fields.
  final Map<String, JustFormFieldState> _fields = {};

  /// Stores the labels of the fields.
  final Map<String, String?> _fieldLabels = {};

  /// Stores the last valid values (after successful saveAll).
  final Map<String, dynamic> _savedValues = {};

  /// Stores all errors of validation after the last call to validateAll().
  /// Key - ID of the field, value - list of errors for this field.
  final Map<String, FieldErrorInfo> _errors = {};

  /// Returns an unmodifiable map of the current errors of validation.
  Map<String, FieldErrorInfo> get fieldValidatiionInfo =>
      Map.unmodifiable(_errors);

  /// Returns true if there are errors after the last call to validateAll().
  bool get hasErrors => _errors.values.any((info) => info.errors.isNotEmpty);

  /// Registers the state of the field with a unique identifier [id].
  /// Usually called from `initState` or `didChangeDependencies` of the field.
  void registerField(
    String id,
    JustFormFieldState fieldState, {
    String? fieldLabel,
  }) {
    if (_fields.containsKey(id)) {
      if (kDebugMode) {
        print(
          'Warning: $runtimeType: Field with ID "$id" is already registered. Overwriting.',
        );
      }
    }
    _fields[id] = fieldState;
    _fieldLabels[id] = fieldLabel; // Сохраняем метку
  }

  /// Unregisters the field with the given [id].
  /// Usually called from `dispose` of the field.
  void unregisterField(String id) {
    if (_fields.containsKey(id)) {
      _fields.remove(id);
      _fieldLabels.remove(id);
      _errors.remove(id);
      _savedValues.remove(id);
    }
  }

  /// Returns the current value of the field with the given [fieldId].
  /// Returns null if the field is not found or its value is null.
  /// The [T] type must match the expected type of the field value.
  T? getValue<T>(String fieldId) {
    final fieldState = _fields[fieldId];
    if (fieldState != null) {
      try {
        return fieldState.currentValue as T?;
      } catch (e) {
        if (kDebugMode) {
          print(
            'Warning: JustFormController.getValue:'
            ' Error converting type for field '
            '"$fieldId". Expected $T, got '
            '${fieldState.currentValue.runtimeType}. $e',
          );
        }
        return null;
      }
    }
    if (kDebugMode) {
      print(
        'Warning: JustFormController.getValue: '
        'Attempt to get value for unregistered field "$fieldId"',
      );
    }
    return null;
  }

  /// Returns a map of the current values of all registered fields.
  Map<String, dynamic> getAllValues() {
    final values = <String, dynamic>{};
    _fields.forEach((id, state) {
      values[id] = state.currentValue;
    });
    return values;
  }

  /// Returns a map of the saved values after the last call to [saveAll].
  Map<String, dynamic> getSavedValues() {
    return Map.unmodifiable(_savedValues);
  }

  /// Validates all registered fields of the form.
  /// Updates the state of the errors [fieldValidatiionInfo].
  /// Notifies listeners about the change of the state of the errors.
  /// Returns `true` if all fields are valid, otherwise `false`.
  bool validateAll() {
    _errors.clear();
    bool isFormValid = true;

    _fields.forEach((id, fieldState) {
      final fieldErrors = fieldState.validateField();
      if (fieldErrors.isNotEmpty) {
        isFormValid = false;
        final label = _fieldLabels[id];
        _errors[id] = FieldErrorInfo(errors: fieldErrors, label: label);
        final errorToDisplay =
            !fieldState.hideError ? fieldErrors.first.message : null;
        fieldState.setFieldError(errorToDisplay);
      } else {
        fieldState.setFieldError(null);
      }
    });

    notifyListeners();
    return isFormValid;
  }

  /// Resets all registered fields to their initial values.
  /// Clears the error state and saved values.
  /// Notifies listeners.
  void resetAll() {
    for (var fieldState in _fields.values) {
      fieldState.resetField();
    }
    _errors.clear();
    _savedValues.clear();
    notifyListeners();
  }

  /// Calls `saveField` on all registered fields.
  /// Updates the saved values map [getSavedValues].
  void saveAll() {
    _savedValues.clear();
    _fields.forEach((id, fieldState) {
      fieldState.saveField();
      _savedValues[id] = fieldState.currentValue;
    });
  }

  @override
  void dispose() {
    _fields.clear();
    _errors.clear();
    _savedValues.clear();
    super.dispose();
  }
}
