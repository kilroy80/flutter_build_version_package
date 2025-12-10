import 'package:meta/meta.dart';

/// Example usage of @GenerateBuildVersion()
///
/// ```dart
/// import 'package:flutter_build_version/flutter_build_version.dart';
///
/// part 'app_version.gb.dart';
///
/// @GenerateBuildVersion()
/// abstract class _AppVersion {}
/// ```
///
/// dart run or watch [build_runner]
///
/// ```bash
/// dart run build_runner build --delete-conflicting-outputs
/// ```
///
/// After running, generate file use
///
/// ```dart
/// debugPrint(AppVersion.flutterVersion); // e.g. "3.38.0"
/// debugPrint(AppVersion.dartVersion);    // e.g. "3.10.1"
/// ```
///
/// const [GenerateBuildVersion] Annotation
@immutable
class GenerateBuildVersion {
  const GenerateBuildVersion();
}