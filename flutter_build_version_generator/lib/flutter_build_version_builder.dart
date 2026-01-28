import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:flutter_build_version/flutter_build_version.dart';
import 'package:source_gen/source_gen.dart';

class FlutterBuildVersionGenerator
    extends GeneratorForAnnotation<GenerateBuildVersion> {

  @override
  Future<String> generateForAnnotatedElement(
      Element element,
      ConstantReader annotation,
      BuildStep buildStep,
      ) async {

    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@GenerateBuildVersion can only be applied to classes.',
        element: element,
      );
    }

    if (!element.isAbstract) {
      throw InvalidGenerationSourceError(
        '@GenerateBuildVersion can only be applied to abstract classes.\n'
            'Found: ${element.name}',
        element: element,
      );
    }

    if (!element.name!.startsWith('_')) {
      throw InvalidGenerationSourceError(
        'The class "${element.name}" must start with "_" '
            'when using @GenerateBuildVersion.',
        element: element,
      );
    }

    var versionJson = await ProcessExecute().run();

    final flutterVersion = versionJson['frameworkVersion'] ?? 'unknown';
    final flutterChannel = versionJson['channel'] ?? 'unknown';
    final dartVersion = versionJson['dartSdkVersion'] ?? 'unknown';
    final devToolsVersion = versionJson['devToolsVersion'] ?? 'unknown';

    final originalFileName = buildStep.inputId.pathSegments.last;

    final abstractClassName = element.name ?? originalFileName.split('.').first;

    final className = abstractClassName.substring(1);
    final implClassName = className[0].toUpperCase() + className.substring(1);

    return '''
part of '$originalFileName';

class $implClassName extends $abstractClassName {
  static const String flutterVersion = '$flutterVersion';
  static const String flutterChannel = '$flutterChannel';
  static const String dartVersion = '$dartVersion';
  static const String devToolsVersion = '$devToolsVersion';
}
''';
  }
}

Builder flutterBuildVersionBuilder(BuilderOptions options) =>
    LibraryBuilder(
      FlutterBuildVersionGenerator(),
      generatedExtension: '.gb.dart',
    );


/// Lazy singleton class
class ProcessExecute {
  static final ProcessExecute _instance = ProcessExecute._();
  factory ProcessExecute() => _instance;

  ProcessExecute._();

  Map<String, dynamic> _versionJson = <String, dynamic>{};

  Future<Map<String, dynamic>> run() async {
    if (_versionJson.isEmpty) {
      var command = Platform.isWindows ? 'flutter.bat' : 'flutter';
      final result = await Process.run(
        command,
        ['--version', '--machine'],
        runInShell: true,
      );

      if (result.exitCode != 0) {
        throw Exception('Error running flutter --version: ${result.stderr}');
      }

      _versionJson = json.decode(result.stdout);
      return _versionJson;
    }
    return _versionJson;
  }
}