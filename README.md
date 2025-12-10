# Flutter Build Version
A lightweight code generator that automatically produces a concrete class containing the current Flutter/Dart version information.
This follows a pattern where the user declares an abstract class using an annotation, and then a generator creates the implementing class.

---

## Features

- Automatically generates a class that exposes Flutter / Dart version information.
- Strong usage validation to prevent incorrect annotation usage.
- Clean naming strategy:
    - Users define an abstract class starting with `_`
    - Generator produces a public, concrete class without the leading `_`.

---

##  Usage Example

### Install the package

```dart
dependencies:
  flutter_build_version:
    git:
      url: https://github.com/kilroy80/flutter_build_version
      path: "flutter_build_version"

dev_dependencies:
  flutter_build_version_generator:
    git:
      url: https://github.com/kilroy80/flutter_build_version
      path: "flutter_build_version_generator"
```

### Define an annotated abstract class

```dart
import 'package:flutter_build_version/flutter_build_version.dart';

part 'app_version.gb.dart';

@GenerateBuildVersion()
abstract class _AppVersion {}
```

### After running `build_runner`, this will generate:

```dart
part of 'app_version.dart';

class AppVersion extends _AppVersion {
  static const String flutterVersion = '3.38.4';
  static const String flutterChannel = 'stable';
  static const String dartVersion = '3.10.3';
  static const String devToolsVersion = '2.51.1';
}
```

Use it like this:

```dart
debugPrint(AppVersion.flutter);
```

---

## Running the Generator

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Usage Rules (IMPORTANT)

To ensure consistent behavior, the following strict rules are enforced by the generator:

### Rule 1: The annotated class **must be abstract**
Correct:

```dart
@GenerateBuildVersion()
abstract class _AppVersion {}
```

Incorrect:

```dart
@GenerateBuildVersion()
class _AppVersion {} // Not abstract → Error
```

---

### Rule 2: Class name **must start with an underscore `_`**
Correct:

```dart
@GenerateBuildVersion()
abstract class _AppInfo {}
```

Incorrect:

```dart
@GenerateBuildVersion()
abstract class AppInfo {} //  Missing _ prefix → Error
```

---

### Rule 3: Do NOT use annotation on non-class elements

Incorrect:

```dart
@GenerateBuildVersion()
void something() {} // Error
```

---

## Naming Strategy

If user defines:

```
abstract class _AppVersion {}
```

Generator will:

- Remove leading `_`
- Capitalize if needed
- Produce:

```
_AppVersion → AppVersion
```

Generated code:

```dart
class AppVersion extends _AppVersion { ... }
```

---

## File Generation

User file:

```
lib/src/app_version.dart
```

Generated:

```
lib/src/app_version.gb.dart
```

---

## License

See the `LICENSE` file for details.
