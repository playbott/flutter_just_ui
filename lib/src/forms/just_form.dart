import 'package:flutter/material.dart';
import 'just_form_controller.dart';

/// Internal InheritedWidget for providing JustFormController
/// to child widgets (form fields).
class _JustFormScope extends InheritedWidget {
  final JustFormController controller;

  const _JustFormScope({required this.controller, required super.child});

  @override
  bool updateShouldNotify(_JustFormScope oldWidget) {
    return controller != oldWidget.controller;
  }
}

/// Widget container for form, controlled by [JustFormController].
/// Provides the controller to child widgets via InheritedWidget.
class JustForm extends StatefulWidget {
  const JustForm({super.key, required this.controller, required this.child});

  /// The controller for JustForm.
  final JustFormController controller;

  /// The widget below this widget in the tree. [JustForm] finds child widgets
  /// contains JustFormFields and passes them the controller.
  final Widget child;

  /// Returns the [JustFormController] of the closest [JustForm] widget
  /// which encloses the given context.
  static JustFormController? maybeControllerOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_JustFormScope>();
    return scope?.controller;
  }

  @override
  State<JustForm> createState() => _JustFormState();
}

class _JustFormState extends State<JustForm> {
  @override
  Widget build(BuildContext context) {
    return _JustFormScope(controller: widget.controller, child: widget.child);
  }
}
