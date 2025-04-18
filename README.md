# Just UI

A lightweight and utilitarian UI package for Flutter, focused on business applications.

⚠️ This package is in early alpha and not ready for production use. The API is unstable and subject to change.
Please avoid using `just_ui` in real applications until a stable release is available.

## Installation

Add to `pubspec.yaml`:

```yaml
dependencies:
  just_ui: ^0.0.1
```

## Usage

### Components

```dart
import 'package:just_ui/just_ui_components.dart';

JustTextField(
  label: 'Email',
  hint: 'Enter your email',
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
)
```

### Forms

```dart
import 'package:just_ui/just_ui_forms.dart';

JustForm(
  fields: [
    JustTextField(
      label: 'Email',
      hint: 'Enter your email',
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
    ),
  ],
  onSubmit: (data) => print(data),
)
```

### Theme
```dart
import 'package:just_ui/just_ui_theme.dart';

MaterialApp(
  theme: JustTheme.light(),
  home: YourWidget(),
)
```
