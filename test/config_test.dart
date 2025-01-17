import 'package:flutter_launcher_icons/config/config.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import './templates.dart' as templates;

void main() {
  group('Config', () {
    late String prefixPath;
    setUpAll(() {
      prefixPath = path.join(d.sandbox, 'fli_test');
    });
    group('#loadConfigFromPath', () {
      setUpAll(() async {
        await d.dir('fli_test', [
          d.file('flutter_launcher_icons.yaml', templates.fliConfigTemplate),
          d.file('invalid_fli_config.yaml', templates.invalidfliConfigTemplate),
        ]).create();
      });
      test('should return valid configs', () {
        final configs = Config.loadConfigFromPath(
          'flutter_launcher_icons.yaml',
          prefixPath,
        );
        expect(configs, isNotNull);
        // android configs
        expect(configs!.android, isTrue);
        expect(configs.imagePath, isNotNull);
        expect(configs.imagePathAndroid, isNotNull);
        expect(configs.adaptiveIconBackground, isNotNull);
        expect(configs.adaptiveIconForeground, isNotNull);
        expect(configs.minSdkAndroid, equals(21));
        // ios configs
        expect(configs.ios, isTrue);
        expect(configs.imagePathIOS, isNotNull);
        expect(configs.removeAlphaIOS, isFalse);
        // web configs
        expect(configs.webConfig, isNotNull);
        expect(configs.webConfig!.generate, isTrue);
        expect(configs.webConfig!.backgroundColor, isNotNull);
        expect(configs.webConfig!.imagePath, isNotNull);
        expect(configs.webConfig!.themeColor, isNotNull);
        expect(
          configs.webConfig!.toJson(),
          equals(<String, dynamic>{
            'generate': true,
            'image_path': 'app_icon.png',
            'image_path_favicon': null,
            'background_color': '#0175C2',
            'theme_color': '#0175C2',
          }),
        );
        // windows
        expect(configs.windowsConfig, isNotNull);
        expect(configs.windowsConfig!.generate, isNotNull);
        expect(configs.windowsConfig!.iconSize, isNotNull);
        expect(configs.windowsConfig!.imagePath, isNotNull);
        expect(
          configs.windowsConfig!.toJson(),
          equals(<String, dynamic>{
            'generate': true,
            'image_path': 'app_icon.png',
            'icon_size': 48,
          }),
        );
        // macos
        expect(configs.macOSConfig, isNotNull);
        expect(configs.macOSConfig!.generate, isNotNull);
        expect(configs.macOSConfig!.imagePath, isNotNull);
        expect(
          configs.macOSConfig!.toJson(),
          equals(<String, dynamic>{
            'generate': true,
            'image_path': 'app_icon.png',
          }),
        );
      });

      test('should return null when invalid filePath is given', () {
        final configs = Config.loadConfigFromPath(
          'file_that_dont_exist.yaml',
          prefixPath,
        );
        expect(configs, isNull);
      });

      test('should throw InvalidConfigException when config is invalid', () {
        expect(
          () => Config.loadConfigFromPath(
            'invalid_fli_config.yaml',
            prefixPath,
          ),
          throwsA(isA<InvalidConfigException>()),
        );
      });
    });
    group('#loadConfigFromTestPubSpec', () {
      test('should return valid configs', () {
        const String path = 'test/config/test_pubspec.yaml';
        final configs = Config.loadConfigFromPath(path, '.');
        expect(configs, isNotNull);
        const String imagePath = 'assets/images/icon-710x599.png';
        expect(configs!.imagePath, equals(imagePath));
        // android configs
        expect(configs.android, isTrue);
        expect(configs.imagePathAndroid, isNull);
        expect(configs.getImagePathAndroid(), equals(imagePath));
        expect(configs.adaptiveIconBackground, isNull);
        expect(configs.adaptiveIconForeground, isNull);
        expect(configs.minSdkAndroid, equals(21));
        // ios configs
        expect(configs.ios, isTrue);
        expect(configs.imagePathIOS, isNull);
        expect(configs.getImagePathIOS(), equals(imagePath));
        expect(configs.removeAlphaIOS, isFalse);
        // web configs
        expect(configs.webConfig, isNull);
        // windows
        expect(configs.windowsConfig, isNull);
        // macos
        expect(configs.macOSConfig, isNull);
      });
    });
    group('#loadConfigFromPubSpec', () {
      setUpAll(() async {
        await d.dir('fli_test', [
          d.file('pubspec.yaml', templates.pubspecTemplate),
          d.file('flutter_launcher_icons.yaml', templates.fliConfigTemplate),
          d.file('invalid_fli_config.yaml', templates.invalidfliConfigTemplate),
        ]).create();
      });
      test('should return valid configs', () {
        final configs = Config.loadConfigFromPubSpec(prefixPath);
        expect(configs, isNotNull);
        // android configs
        expect(configs!.android, isTrue);
        expect(configs.imagePath, isNotNull);
        expect(configs.imagePathAndroid, isNotNull);
        expect(configs.adaptiveIconBackground, isNotNull);
        expect(configs.adaptiveIconForeground, isNotNull);
        expect(configs.minSdkAndroid, equals(21));
        // ios configs
        expect(configs.ios, isTrue);
        expect(configs.imagePathIOS, isNotNull);
        expect(configs.removeAlphaIOS, isFalse);
        // web configs
        expect(configs.webConfig, isNotNull);
        expect(configs.webConfig!.generate, isTrue);
        expect(configs.webConfig!.backgroundColor, isNotNull);
        expect(configs.webConfig!.imagePath, isNotNull);
        expect(configs.webConfig!.themeColor, isNotNull);
        expect(
          configs.webConfig!.toJson(),
          equals(<String, dynamic>{
            'generate': true,
            'image_path': 'app_icon.png',
            'image_path_favicon': 'app_icon.png',
            'background_color': '#0175C2',
            'theme_color': '#0175C2',
          }),
        );
        // windows
        expect(configs.windowsConfig, isNotNull);
        expect(configs.windowsConfig!.generate, isNotNull);
        expect(configs.windowsConfig!.iconSize, isNotNull);
        expect(configs.windowsConfig!.imagePath, isNotNull);
        expect(
          configs.windowsConfig!.toJson(),
          equals(<String, dynamic>{
            'generate': true,
            'image_path': 'app_icon.png',
            'icon_size': 48,
          }),
        );
        // macos
        expect(configs.macOSConfig, isNotNull);
        expect(configs.macOSConfig!.generate, isNotNull);
        expect(configs.macOSConfig!.imagePath, isNotNull);
        expect(
          configs.macOSConfig!.toJson(),
          equals(<String, dynamic>{
            'generate': true,
            'image_path': 'app_icon.png',
          }),
        );
      });

      group('should throw', () {
        setUp(() async {
          await d.dir('fli_test', [
            d.file('pubspec.yaml', templates.invalidPubspecTemplate),
            d.file('flutter_launcher_icons.yaml', templates.fliConfigTemplate),
            d.file(
              'invalid_fli_config.yaml',
              templates.invalidfliConfigTemplate,
            ),
          ]).create();
        });
        test('InvalidConfigException when config is invalid', () {
          expect(
            () => Config.loadConfigFromPubSpec(prefixPath),
            throwsA(isA<InvalidConfigException>()),
          );
        });
      });
    });
    group('#loadConfigFromFlavor', () {
      setUpAll(() async {
        await d.dir('fli_test', [
          d.file(
            'flutter_launcher_icons-development.yaml',
            templates.flavorFLIConfigTemplate,
          ),
        ]).create();
      });
      test('should return valid config', () {
        final configs = Config.loadConfigFromFlavor(
          'development',
          prefixPath,
        );
        expect(configs, isNotNull);
        expect(configs!.android, isTrue);
        expect(configs.imagePath, isNotNull);
        expect(configs.imagePathAndroid, isNotNull);
        expect(configs.adaptiveIconBackground, isNotNull);
        expect(configs.adaptiveIconForeground, isNotNull);
        // ios configs
        expect(configs.ios, isTrue);
        expect(configs.imagePathIOS, isNotNull);
        // web configs
        expect(configs.webConfig, isNotNull);
        expect(configs.webConfig!.generate, isTrue);
        expect(configs.webConfig!.backgroundColor, isNotNull);
        expect(configs.webConfig!.imagePath, isNotNull);
        expect(configs.webConfig!.themeColor, isNotNull);
        expect(
          configs.webConfig!.toJson(),
          equals(<String, dynamic>{
            'generate': true,
            'image_path': 'app_icon.png',
            'image_path_favicon': null,
            'background_color': '#0175C2',
            'theme_color': '#0175C2',
          }),
        );
        // windows
        expect(configs.windowsConfig, isNotNull);
        expect(configs.windowsConfig!.generate, isNotNull);
        expect(configs.windowsConfig!.iconSize, isNotNull);
        expect(configs.windowsConfig!.imagePath, isNotNull);
        expect(
          configs.windowsConfig!.toJson(),
          equals(<String, dynamic>{
            'generate': true,
            'image_path': 'app_icon.png',
            'icon_size': 48,
          }),
        );
        // macos
        expect(configs.macOSConfig, isNotNull);
        expect(configs.macOSConfig!.generate, isNotNull);
        expect(configs.macOSConfig!.imagePath, isNotNull);
        expect(
          configs.macOSConfig!.toJson(),
          equals(<String, dynamic>{
            'generate': true,
            'image_path': 'app_icon.png',
          }),
        );
      });
    });
  });
}
