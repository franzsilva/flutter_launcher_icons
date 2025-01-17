import 'dart:io';

import 'package:flutter_launcher_icons/abs/icon_generator.dart';
import 'package:flutter_launcher_icons/config/config.dart';
import 'package:flutter_launcher_icons/logger.dart';
import 'package:flutter_launcher_icons/web/web_icon_generator.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../templates.dart' as templates;

void main() {
  group('WebIconGenerator', () {
    late IconGeneratorContext context;
    late IconGenerator generator;
    late Config config;
    late String prefixPath;
    final assetPath = path.join(Directory.current.path, 'test', 'assets');

    setUp(() async {
      final imageFile = File(path.join(assetPath, 'app_icon.png'));
      expect(imageFile.existsSync(), isTrue);
      await d.dir('fli_test', [
        d.dir('web', [
          d.dir('icons'),
          d.file('index.html', templates.webIndexTemplate),
          d.file('manifest.json', templates.webManifestTemplate),
        ]),
        d.file('flutter_launcher_icons.yaml', templates.fliWebConfig),
        d.file('pubspec.yaml', templates.pubspecTemplate),
        d.file('app_icon.png', imageFile.readAsBytesSync()),
        d.file('app_icon_favicon.png', imageFile.readAsBytesSync()),
      ]).create();
      prefixPath = path.join(d.sandbox, 'fli_test');
      config = Config.loadConfigFromPath(
        'flutter_launcher_icons.yaml',
        prefixPath,
      )!;
      context = IconGeneratorContext(
        config: config,
        prefixPath: prefixPath,
        logger: FLILogger(false),
      );
      generator = WebIconGenerator(context);
    });

    // end to end test
    test('should generate valid icons', () async {
      expect(generator.validateRequirements(), isTrue);
      generator.createIcons();
      await expectLater(
        d.dir('fli_test', [
          d.dir('web', [
            d.dir('icons', [
              // this icons get created in fs
              d.file('Icon-192.png', anything),
              d.file('Icon-512.png', anything),
              d.file('Icon-maskable-192.png', anything),
              d.file('Icon-maskable-512.png', anything),
            ]),
            // this favicon get created in fs
            d.file('favicon.png', anything),
            d.file('index.html', anything),
            // this manifest.json get updated in fs
            d.file('manifest.json', anything),
          ]),
          d.file('flutter_launcher_icons.yaml', anything),
          d.file('pubspec.yaml', templates.pubspecTemplate),
        ]).validate(),
        completes,
      );
    });
  });
}
