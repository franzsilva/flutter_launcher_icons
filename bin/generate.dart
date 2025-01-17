import 'dart:io';

import 'package:args/args.dart';

import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/src/version.dart';

const _defaultConfigFileName = './flutter_launcher_icons.yaml';

/// The function will be called from command line
/// using the following command:
/// ```sh
/// flutter pub run flutter_launcher_icons:generate
/// ```
///
/// Calling this function will generate a flutter_launcher_icons.yaml file
/// with a default config template.
///
/// This command can take 2 optional arguments:
/// - --override: This will override the current `flutter_launcher_icons.yaml`
/// file if it exists, if not provided, the file will not be overridden and
/// a message will be printed to the console.
///
/// - --fileName: This flag will take a file name as an argument and
/// will generate the config format in that file instead of the default
/// `flutter_launcher_icons.yaml` file, if not provided,
/// the default file will be used.
void main(List<String> arguments) {
  print(introMessage(packageVersion));

  final parser = ArgParser()
    ..addFlag('override', abbr: 'o', defaultsTo: false)
    ..addOption(
      'fileName',
      abbr: 'f',
      defaultsTo: _defaultConfigFileName,
    );

  final results = parser.parse(arguments);
  final override = results['override'] as bool;
  final fileName = results['fileName'] as String;

  // Check if fileName is valid and has a .yaml extension
  if (!fileName.endsWith('.yaml')) {
    print('Invalid file name, please provide a valid file name');
    return;
  }

  final file = File(fileName);
  if (file.existsSync()) {
    if (override) {
      print('File already exists, overriding...');
      _generateConfigFile(file);
    } else {
      print(
        'File already exists, use --override flag to override the file, or use --fileName flag to use a different file name',
      );
    }
  } else {
    try {
      file.createSync(recursive: true);
      _generateConfigFile(file);
    } on Exception catch (e) {
      print('Error creating file: $e');
    }
  }
}

void _generateConfigFile(File configFile) {
  try {
    configFile.writeAsStringSync(_configFileTemplate);

    print('\nConfig file generated successfully 🎉');
    print(
      'You can now use this new config file by using the command below:\n\n'
      'flutter pub run flutter_launcher_icons'
      '${configFile.path == _defaultConfigFileName ? '' : ' -f ${configFile.path}'}\n',
    );
  } on Exception catch (e) {
    print('Error generating config file: $e');
  }
}

const _configFileTemplate = '''
# flutter pub run flutter_launcher_icons
flutter_launcher_icons:
  image_path: "assets/icon/icon.png"

  android: "launcher_icon"
  # image_path_android: "assets/icon/icon.png"
  min_sdk_android: 21 # android min sdk min:16, default 21
  # adaptive_icon_background: "assets/icon/background.png"
  # adaptive_icon_foreground: "assets/icon/foreground.png"
  # adaptive_icon_foreground_inset: 16
  # adaptive_icon_monochrome: "assets/icon/monochrome.png"

  ios: true
  # image_path_ios: "assets/icon/icon.png"
  remove_alpha_ios: true
  # image_path_ios_dark_transparent: "assets/icon/icon_dark.png"
  # image_path_ios_tinted_grayscale: "assets/icon/icon_tinted.png"
  # desaturate_tinted_to_grayscale_ios: true
  # background_color_ios: "#ffffff"

  web:
    generate: true
    image_path: "path/to/image.png"
    background_color: "#hexcode"
    theme_color: "#hexcode"

  windows:
    generate: true
    image_path: "path/to/image.png"
    icon_size: 48 # min:48, max:256, default: 48

  macos:
    generate: true
    image_path: "path/to/image.png"
''';
