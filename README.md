# Just UI

[![pub version][pub-version-shield]][pub-version-link] [![License: MIT][license-shield]][license-link][![Flutter Version][flutter-version]][flutter-link] [![Platform Support][platforms-shield]][platforms-link]

`just_ui` is a lightweight Flutter UI package focused on simplicity, readability, and easy form validation. It offers essential UI components, mainly for forms.

## Contents

* [Features](#features)
* [Roadmap (Planned Widgets)](#planned-features)
* [Getting Started](#getting-started)
* [Key Features & Usage](#key-features-and-usage)
* [JustFormController](#justformcontroller)
* [JustTextField](#justtextfield)
* [Validators](#validators)
* [Included Validators](#included-validators)
* [Contributing](#contributing)
* [License](#license)

## Features

*   **Lightweight:** Minimal set of utility-focused widgets.
*   **`JustTextField`:** A versatile text field that integrates seamlessly with both `JustForm` and standard Flutter `Form`.
*   **`JustForm` & `JustFormController`:** Centralized state management for your forms. Easily validate, retrieve values, access errors, and reset fields.
*   **Declarative Validators:** Reusable validator classes (e.g., `RequiredValidator`, `EmailValidator`) for clean validation logic. Easily extendable.
*   **Standard Form Compatibility:** Use `JustTextField` within a standard Flutter `Form`.
*   **Clear Error Handling:** Programmatic access to validation errors.

## Planned features

Potential additions to enhance the package could include:

*   Multi-line **text area** input.
*   **Dropdown/Select** list field.
*   **Checkbox** input field.
*   **Switch** (toggle) input field.
*   **Radio button** group selection field.
*   **Time picker** field.
*   **Date picker** field.
*   **Date & Time** picker field.
*   **Slider** input field.
*   Support for **multi-step forms** (**Wizard** layout).
*   Expanded **theme** and **customization** options.
*   **File selection** field.
*   **Image selection** field.
*   Integrated **data table** display.
*   Additional built-in **validators** (e.g., for comparisons, ranges).
 
*This list is tentative and subject to change.*

## Getting Started

Add `just_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  just_ui: ^latest # Replace with the latest version
```

Then, run `flutter pub get`.

Import the package:

```dart
import 'package:just_ui/just_ui.dart';
```

## Key Features and Usage

This section highlights the core components and how to interact with them.


### `JustFormController`

Manages the state of your `JustForm`, acting as the central hub for validation, data access, and error handling.

```dart
  // 1. Create an instance (typically in a StatefulWidget's State)
  final formController = JustFormController();

  // ... (Assume JustForm and JustTextFields with IDs like 'email', 'password' are set up)

  // 2. Validate all registered fields within a JustForm
  // Returns true if all fields are valid, false otherwise.
  bool isValid = formController.validateAll();

  // 3. Get current values from all fields
  // Returns a Map<String, dynamic> where keys are field IDs.
  Map<String, dynamic> allValues = formController.getAllValues();

  // 4. Get the current value of a specific field by ID
  // Use the expected type <T>. Returns null if field not found or value is null.
  String? emailValue = formController.getValue<String>('email');
  String? passwordValue = formController.getValue<String>('password');

  // 5. Access validation errors after calling validateAll()
  // Returns a Map<String, FieldErrorInfo>.
  // This is powerful: for each invalid field (keyed by its ID), FieldErrorInfo gives you:
  //   - `errors`: A list of `ValidationError` objects for that field.
  //   - `label`: The user-friendly field name (like "Email", "Password")
  //              if you provided one via `InputDecoration.labelText` in your `JustTextField`.
  // This makes displaying comprehensive error summaries easy!
  Map<String, FieldErrorInfo> errors = formController.fieldValidatiionInfo;
  if (formController.hasErrors) {
    print("Please fix the following issues:");
    errors.forEach((fieldId, errorInfo) {
      // Use the label for user-facing messages, fallback to ID if no label was set
      String fieldIdentifier = errorInfo.label ?? fieldId;
      String errorMessages = errorInfo.errors.map((e) => e.message).join(', ');
      print('- $fieldIdentifier: $errorMessages');
      // Example Output:
      // - Email: Enter a valid email address
      // - password: Minimum length: 8 characters
    });
  }

  // 6. Reset all fields to their initial values and clear errors
  formController.resetAll();

  // 7. IMPORTANT: Dispose the controller when done (in State's dispose method)
  @override
  void dispose() {
    formController.dispose();
    super.dispose();
  }
```

### `JustTextField`

The primary input widget. Integrates with both `JustForm` and standard `Form`.

**Usage with `JustForm`:**

```dart
// Wrap fields with JustForm and provide the controller
JustForm(
  controller: formController,
  child: Column(
    children: [
      JustTextField(
        // Required ID for controller integration
        id: 'user_email',
        decoration: const InputDecoration(labelText: 'Email'),
        // List of validators managed by JustFormController
        validators: [RequiredValidator(), EmailValidator()],
      ),
      // Other JustTextField or Just UI fields...
    ],
  ),
)
```

**Usage with standard Flutter `Form`:**

```dart
// Use standard Form and FormKey
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      JustTextField(
        // Use standard TextEditingController if needed outside Form handlers
        controller: _emailController,
        decoration: const InputDecoration(labelText: 'Email'),
        // Validators are still used by JustTextField for error display,
        // but FormKey validation triggers them.
        validators: [RequiredValidator(), EmailValidator()],
        // Alternatively, or in addition, use the standard validator:
        // validator: (value) {
        //   if (value == null || value.isEmpty) return 'Required!';
        //   if (!EmailValidator().validate(value)) return 'Invalid Email!';
        //   return null; // Valid
        // },
      ),
    ],
  ),
)
```

### Validators

Reusable classes for defining validation rules.

```dart
JustTextField(
  id: 'password',
  validators: [
    // Ensures the field is not empty
    RequiredValidator(),
    // Ensures the field has at least 8 characters
    MinLengthValidator(8, customErrorMessage: 'Password needs minimum 8 chars.'),
    // Ensures the field has maximum 50 characters
    MaxLengthValidator(50),
  ],
  // ... other properties
)

// You can create custom validators:
class MyCustomValidator implements JustValidator<String> {
  @override
  String? customErrorMessage;
  
  @override
  String get defaultErrorMessage => 'Invalid input based on custom rule.';

  MyCustomValidator({this.customErrorMessage});

  @override
  String? validate(String? value) {
    if (value != 'expected_value') {
      return customErrorMessage ?? defaultErrorMessage;
    }
    return null; // Value is valid
  }
}
```

## Included Validators

`just_ui` comes with a set of common validators:

*   `RequiredValidator`
*   `EmailValidator`
*   `MinLengthValidator`
*   `MaxLengthValidator`
*   `NumbersOnlyValidator`
*   `LettersOnlyValidator`
*   `LettersAndNumbersValidator`
*   `UrlValidator`
*   `IpAddressValidator`
*   `IsTrueValidator` (for booleans/checkboxes)

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue. If you'd like to contribute code, please feel free to open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<!-- Link Definitions -->
[pub-version-shield]: https://img.shields.io/pub/v/just_ui?logo=dart&logoColor=white
[pub-version-link]: https://pub.dev/packages/just_ui
[license-shield]: https://img.shields.io/badge/license-BSD--3--Clause-pink
[license-link]: https://opensource.org/licenses/BSD-3-Clause
[flutter-version]: https://img.shields.io/badge/Flutter-%3E%3D3.0.0-blue.svg
[flutter-link]: https://flutter.dev
[platforms-shield]: https://img.shields.io/badge/Platform-%20iOS%20|Android%20|%20Web%20|%20Desktop-blue
[platforms-link]: https://flutter.dev/multi-platform

