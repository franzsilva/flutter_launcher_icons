import 'dart:io';

import 'package:checked_yaml/checked_yaml.dart' as yaml;
import 'package:flutter_launcher_icons/config/macos_config.dart';
import 'package:flutter_launcher_icons/config/web_config.dart';
import 'package:flutter_launcher_icons/config/windows_config.dart';
import 'package:flutter_launcher_icons/constants.dart' as constants;
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/utils.dart' as utils;
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as path;

part 'config.g.dart';

/// A model representing the flutter_launcher_icons configuration
@JsonSerializable(
  anyMap: true,
  checked: true,
)
class Config {
  /// Creates an instance of [Config]
  const Config({
    this.imagePath,
    this.android = false,
    this.ios = false,
    this.imagePathAndroid,
    this.imagePathIOS,
    this.imagePathIOSDarkTransparent,
    this.imagePathIOSTintedGrayscale,
    this.adaptiveIconForeground,
    this.adaptiveIconForegroundInset = 16,
    this.adaptiveIconBackground,
    this.adaptiveIconMonochrome,
    this.minSdkAndroid = constants.androidDefaultAndroidMinSDK,
    this.removeAlphaIOS = false,
    this.desaturateTintedToGrayscaleIOS = false,
    this.backgroundColorIOS = '#ffffff',
    this.webConfig,
    this.windowsConfig,
    this.macOSConfig,
  });

  /// Creates [Config] for given [flavor] and [prefixPath]
  static Config? loadConfigFromFlavor(
    String flavor,
    String prefixPath,
  ) {
    return _getConfigFromPubspecYaml(
      prefix: prefixPath,
      pathToPubspecYamlFile: utils.flavorConfigFile(flavor),
    );
  }

  /// Loads flutter launcher icons configs from given [filePath]
  static Config? loadConfigFromPath(String filePath, String prefixPath) {
    return _getConfigFromPubspecYaml(
      prefix: prefixPath,
      pathToPubspecYamlFile: filePath,
    );
  }

  /// Loads flutter launcher icons config from `pubspec.yaml` file
  static Config? loadConfigFromPubSpec(String prefix) {
    return _getConfigFromPubspecYaml(
      prefix: prefix,
      pathToPubspecYamlFile: constants.pubspecFilePath,
    );
  }

  static Config? _getConfigFromPubspecYaml({
    required String pathToPubspecYamlFile,
    required String prefix,
  }) {
    final configFile = File(path.join(prefix, pathToPubspecYamlFile));
    if (!configFile.existsSync()) {
      return null;
    }
    final configContent = configFile.readAsStringSync();
    try {
      return yaml.checkedYamlDecode<Config?>(
        configContent,
        (Map<dynamic, dynamic>? json) {
          if (json != null) {
            // if we have flutter_icons configuration ...
            if (json['flutter_icons'] != null) {
              stderr.writeln('\n⚠ Warning: flutter_icons has been deprecated '
                  'please use flutter_launcher_icons instead in your yaml files');
              return Config.fromJson(json['flutter_icons']);
            }
            // if we have flutter_launcher_icons configuration ...
            if (json['flutter_launcher_icons'] != null) {
              return Config.fromJson(json['flutter_launcher_icons']);
            }
          }
          return null;
        },
        allowNull: true,
      );
    } on yaml.ParsedYamlException catch (e) {
      throw InvalidConfigException(e.formattedMessage);
    } catch (e) {
      rethrow;
    }
  }

  /// Generic image_path
  @JsonKey(name: 'image_path')
  final String? imagePath;

  /// Returns true or path if android config is enabled
  final dynamic android; // path or bool

  /// Returns true or path if ios config is enabled
  final dynamic ios; // path or bool

  /// Image path specific to android
  @JsonKey(name: 'image_path_android')
  final String? imagePathAndroid;

  /// Image path specific to ios
  @JsonKey(name: 'image_path_ios')
  final String? imagePathIOS;

  /// IOS image_path_ios_dark_transparent
  @JsonKey(name: 'image_path_ios_dark_transparent')
  final String? imagePathIOSDarkTransparent;

  /// IOS image_path_ios_tinted_grayscale
  @JsonKey(name: 'image_path_ios_tinted_grayscale')
  final String? imagePathIOSTintedGrayscale;

  /// android adaptive_icon_foreground image
  @JsonKey(name: 'adaptive_icon_foreground')
  final String? adaptiveIconForeground;

  /// android adaptive_icon_foreground inset
  @JsonKey(name: 'adaptive_icon_foreground_inset')
  final int adaptiveIconForegroundInset;

  /// android adaptive_icon_background image
  @JsonKey(name: 'adaptive_icon_background')
  final String? adaptiveIconBackground;

  /// android adaptive_icon_background image
  @JsonKey(name: 'adaptive_icon_monochrome')
  final String? adaptiveIconMonochrome;

  /// Android min_sdk_android
  @JsonKey(name: 'min_sdk_android')
  final int minSdkAndroid;

  /// IOS remove_alpha_ios
  @JsonKey(name: 'remove_alpha_ios')
  final bool removeAlphaIOS;

  /// IOS desaturate_tinted_to_grayscale
  @JsonKey(name: 'desaturate_tinted_to_grayscale_ios')
  final bool desaturateTintedToGrayscaleIOS;

  /// IOS background_color_ios
  @JsonKey(name: 'background_color_ios')
  final String backgroundColorIOS;

  /// Web platform config
  @JsonKey(name: 'web')
  final WebConfig? webConfig;

  /// Windows platform config
  @JsonKey(name: 'windows')
  final WindowsConfig? windowsConfig;

  /// MacOS platform config
  @JsonKey(name: 'macos')
  final MacOSConfig? macOSConfig;

  /// Creates [Config] icons from [json]
  factory Config.fromJson(Map<dynamic, dynamic> json) => _$ConfigFromJson(json);

  /// whether or not there is configuration for adaptive icons for android
  bool get hasAndroidAdaptiveConfig =>
      isNeedingNewAndroidIcon &&
      adaptiveIconForeground != null &&
      adaptiveIconBackground != null;

  /// whether or not there is configuration for monochrome icons for android
  bool get hasAndroidAdaptiveMonochromeConfig {
    return isNeedingNewAndroidIcon && adaptiveIconMonochrome != null;
  }

  /// Checks if contains any platform config
  bool get hasPlatformConfig {
    return ios != false ||
        android != false ||
        webConfig != null ||
        windowsConfig != null ||
        macOSConfig != null;
  }

  /// Whether or not configuration for generating Web icons exist
  bool get hasWebConfig => webConfig != null;

  /// Whether or not configuration for generating Windows icons exist
  bool get hasWindowsConfig => windowsConfig != null;

  /// Whether or not configuration for generating MacOS icons exists
  bool get hasMacOSConfig => macOSConfig != null;

  /// Check to see if specified Android config is a string or bool
  /// String - Generate new launcher icon with the string specified
  /// bool - override the default flutter project icon
  bool get isCustomAndroidFile => android is String;

  /// if we are needing a new Android icon
  bool get isNeedingNewAndroidIcon => android != false;

  /// if we are needing a new iOS icon
  bool get isNeedingNewIOSIcon => ios != false;

  /// Method for the retrieval of the Android icon path
  /// If image_path_android is found, this will be prioritised over the image_path
  /// value.
  String? getImagePathAndroid() => imagePathAndroid ?? imagePath;

  // TODO(RatakondalaArun): refactor after Android & iOS configs will be refactored to the new schema
  // https://github.com/fluttercommunity/flutter_launcher_icons/issues/394
  /// get the image path for IOS
  String? getImagePathIOS() => imagePathIOS ?? imagePath;

  /// Converts config to [Map]
  Map<String, dynamic> toJson() => _$ConfigToJson(this);

  @override
  String toString() => 'FlutterLauncherIconsConfig: ${toJson()}';
}
