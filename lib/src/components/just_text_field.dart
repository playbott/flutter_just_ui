import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/src/validation/just_validator.dart';
import '/src/validation/validation_error.dart';
import '/src/forms/just_form.dart';
import '/src/forms/just_form_controller.dart';
import '/src/forms/just_form_field_state.dart';

/// Custom text field, integrated with the [JustForm] system.
/// You can work either with the standard Flutter [Form] or with [JustFormController].
class JustTextField extends StatefulWidget {
  /// Required if use with [JustFormController]
  final String? id;

  /// Use with [JustFormController]
  final List<JustValidator<String>> validators;

  /// Use with [JustFormController]
  final bool hideError;

  /// Standard [TextFormField] params
  final TextEditingController? controller;
  final String? initialValue;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final FocusNode? focusNode;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool readOnly;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool autofocus;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool? enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final Widget? Function(
    BuildContext, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })?
  buildCounter;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;

  final FormFieldSetter<String>? onSaved;

  /// Use with only standard [Form]
  final FormFieldValidator<String>? validator;

  /// Use with only standard [Form]
  final AutovalidateMode? autovalidateMode;

  const JustTextField({
    super.key,

    // JustForm params
    this.id,
    this.validators = const [],
    this.hideError = false,

    // Standard TextFormField params
    this.controller,
    this.initialValue,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.enabled,
    this.focusNode,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.contextMenuBuilder,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.autofocus = false,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
  }) : assert(
         initialValue == null || controller == null,
         'Cannot provide both an initialValue and a controller.',
       ),
       assert(
         maxLength == null ||
             maxLength == TextField.noMaxLength ||
             maxLength > 0,
       );

  @override
  State<JustTextField> createState() => _JustTextFieldState();
}

class _JustTextFieldState extends State<JustTextField>
    implements JustFormFieldState<String> {
  /// For accessing the standard FormFieldState
  /// (reset, save and getting the value)
  final GlobalKey<FormFieldState<String>> _formFieldKey =
      GlobalKey<FormFieldState<String>>();

  JustFormController? _justFormController;
  bool _isInJustForm = false;

  /// Local controller if external is not provided
  TextEditingController? _localController;

  TextEditingController get _effectiveController =>
      widget.controller ?? _localController!;

  /// Stores the text error set by the controller
  String? _errorTextFromController;

  @override
  String get fieldId => widget.id ?? '';

  @override
  List<JustValidator<String>> get validators => widget.validators;

  @override
  bool get hideError => widget.hideError;

  @override
  String? get currentValue => _effectiveController.text;

  @override
  List<ValidationError> validateField() {
    final List<ValidationError> errors = [];
    if (!_isInJustForm) return errors;

    final value = currentValue;
    for (final validator in widget.validators) {
      final errorMessage = validator.validate(value);
      if (errorMessage != null) {
        errors.add(
          ValidationError(
            fieldId: fieldId,
            validator: validator,
            message: errorMessage,
          ),
        );
      }
    }
    return errors;
  }

  @override
  void setFieldError(String? errorText) {
    if (_errorTextFromController != errorText) {
      setState(() {
        _errorTextFromController = errorText;
        _formFieldKey.currentState?.validate();
      });
    }
  }

  @override
  void resetField() {
    _effectiveController.text = widget.initialValue ?? '';
    _errorTextFromController = null;
    _formFieldKey.currentState?.reset();
    widget.onChanged?.call(_effectiveController.text);
  }

  @override
  void saveField() {
    widget.onSaved?.call(currentValue);
    _formFieldKey.currentState?.save();
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _localController = TextEditingController(text: widget.initialValue);
    }
    _effectiveController.addListener(_handleControllerChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = JustForm.maybeControllerOf(context);
    final bool currentlyInJustForm = controller != null && widget.id != null;

    if (currentlyInJustForm != _isInJustForm ||
        controller != _justFormController) {
      if (_isInJustForm && _justFormController != null) {
        _justFormController!.unregisterField(fieldId);
      }
      _justFormController = controller;
      _isInJustForm = currentlyInJustForm;
      if (_isInJustForm) {
        assert(
          widget.id != null,
          'JustTextField must have a non-empty `id` when used inside JustForm.',
        );
        final fieldLabel = widget.decoration?.labelText; // Получаем labelText
        _justFormController!.registerField(
          fieldId,
          this,
          fieldLabel: fieldLabel, // Передаем метку
        );
        _errorTextFromController = null;
      }
    }
  }

  @override
  void didUpdateWidget(JustTextField oldWidget) {
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      if (oldWidget.controller == null && widget.controller != null) {
        _localController?.removeListener(_handleControllerChanged);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _localController?.dispose();
          _localController = null;
        });
      }

      if (widget.controller != null) {
        if (oldWidget.controller == null ||
            widget.controller != oldWidget.controller) {
          _effectiveController.addListener(_handleControllerChanged);
        }

        if (widget.initialValue != null) {
          _effectiveController.text = widget.initialValue!;
        }
      } else {
        _localController ??= TextEditingController(text: widget.initialValue);
        _localController!.addListener(_handleControllerChanged);
        if (oldWidget.controller != null) {
          _localController!.text = widget.initialValue ?? '';
        }
      }
    }

    if (_isInJustForm && widget.id != oldWidget.id) {
      if (oldWidget.id != null) {
        _justFormController?.unregisterField(oldWidget.id!);
      }
      assert(
        widget.id != null,
        'JustTextField must have a non-empty `id` when used inside JustForm.',
      );
      final fieldLabel = widget.decoration?.labelText;
      _justFormController?.registerField(
        widget.id!,
        this,
        fieldLabel: fieldLabel, // Передаем и здесь
      );
    }
    if (widget.initialValue != oldWidget.initialValue &&
        widget.controller == null) {
      _localController?.text = widget.initialValue ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChanged);

    if (_isInJustForm && widget.id != null) {
      _justFormController?.unregisterField(widget.id!);
    }
    _localController?.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (_formFieldKey.currentState?.value != _effectiveController.text) {
      _formFieldKey.currentState?.didChange(_effectiveController.text);
    }
    widget.onChanged?.call(_effectiveController.text);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: _formFieldKey,
      initialValue: _effectiveController.text,
      onSaved: (value) {
        if (value != null) {
          widget.onSaved?.call(value);
        }
      },
      validator: (value) {
        final String currentValue = value ?? '';
        String? errorToShow;
        if (_isInJustForm) {
          errorToShow = _errorTextFromController;
        } else {
          for (final validator in widget.validators) {
            final errorMessage = validator.validate(currentValue);
            if (errorMessage != null) {
              errorToShow = errorMessage;
              break;
            }
          }
        }
        if (widget.hideError) {
          return null;
        }
        return errorToShow;
      },
      autovalidateMode:
          _isInJustForm
              ? AutovalidateMode.disabled
              : widget.autovalidateMode ?? AutovalidateMode.disabled,
      enabled: widget.enabled ?? true,
      builder: (FormFieldState<String> field) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_effectiveController.text != field.value && field.value != null) {
            _effectiveController.text = field.value!;
          }
        });

        String? displayErrorText;
        if (!widget.hideError) {
          displayErrorText =
              _isInJustForm ? _errorTextFromController : field.errorText;
        }

        return TextField(
          controller: _effectiveController,
          focusNode: widget.focusNode,
          decoration: widget.decoration?.copyWith(errorText: displayErrorText),
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          textInputAction: widget.textInputAction,
          style: Theme.of(context).textTheme.bodyLarge,
          strutStyle: widget.strutStyle,
          textDirection: widget.textDirection,
          textAlign: widget.textAlign,
          textAlignVertical: widget.textAlignVertical,
          autofocus: widget.autofocus,
          readOnly: widget.readOnly,
          contextMenuBuilder: widget.contextMenuBuilder,
          showCursor: widget.showCursor,
          obscuringCharacter: widget.obscuringCharacter,
          obscureText: widget.obscureText,
          enableSuggestions: widget.enableSuggestions ?? true,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onFieldSubmitted,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          maxLength: widget.maxLength,
          buildCounter: widget.buildCounter,
          scrollController: widget.scrollController,
          scrollPhysics: widget.scrollPhysics,
          autofillHints: widget.autofillHints,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          onChanged: (text) {
            field.didChange(text);
            widget.onChanged?.call(text);
          },
        );
      },
    );
  }
}
