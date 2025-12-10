import 'dart:io';

import 'package:flutter_build_version/flutter_build_version.dart';

part 'main.gb.dart';

void main() async {
  print('Build flutter Version  = ${BuildVersion.flutterVersion}');
  print('Build flutter Channel  = ${BuildVersion.flutterChannel}');
  print('Build Dart Version     = ${BuildVersion.dartVersion}, ${Platform.version.split(' ').first}');
  print('Build DevTools Version = ${BuildVersion.devToolsVersion}');
}

@GenerateBuildVersion()
abstract class _BuildVersion {}