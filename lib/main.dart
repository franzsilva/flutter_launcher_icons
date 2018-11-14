import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:dart_config/default_server.dart';
import 'package:flutter_launcher_icons/android.dart' as AndroidLauncherIcons;
import 'package:flutter_launcher_icons/ios.dart' as IOSLauncherIcons;
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/constants.dart';

const fileOption = "file";
const helpFlag = "help";
const defaultConfigFile = "flutter_launcher_icons.yaml";

createIconsFromArguments(List<String> arguments) async {
  var parser = ArgParser(allowTrailingOptions: true);
  parser.addFlag("help", abbr: "h", help: "Usage help", negatable: false);
  // Make default null to differentiate when it is explicitly set
  parser.addOption(fileOption,
      abbr: "f", help: "Config file (default: $defaultConfigFile)");
  var argResults = parser.parse(arguments);

  if (argResults[helpFlag]) {
    stdout.writeln(parser.usage);
    exit(0);
  }

  // Load the config file
  var yamlConfig =
      await loadConfigFileFromArgResults(argResults, verbose: true);
  if (yamlConfig == null) {
    exit(1);
  }

  // Create icons
  try {
    await createIconsFromConfig(yamlConfig);
  } catch (e) {
    stderr.writeln(e);
    exit(2);
  }
}

createIconsFromConfig(Map yamlConfig) async {
  Map config = loadFlutterIconsConfig(yamlConfig);
  if (!isImagePathInConfig(config)) {
    throw InvalidConfigException(errorMissingImagePath);
  }
  if (!hasAndroidOrIOSConfig(config)) {
    throw InvalidConfigException(errorMissingPlatform);
  }
  var minSdk = AndroidLauncherIcons.minSdk();
  if (minSdk < 26 &&
      hasAndroidAdaptiveConfig(config) &&
      !hasAndroidConfig(config)) {
    throw InvalidConfigException(errorMissingRegularAndroid);
  }

  if (isNeedingNewAndroidIcon(config)) {
    AndroidLauncherIcons.createIcons(config);
  }
  if (hasAndroidAdaptiveConfig(config)) {
    AndroidLauncherIcons.createAdaptiveIcons(config);
  }
  if (isNeedingNewIOSIcon(config)) {
    IOSLauncherIcons.createIcons(config);
  }
}

Future<Map> loadConfigFileFromArgResults(ArgResults argResults,
    {bool verbose}) async {
  verbose ??= false;
  String configFile = argResults[fileOption];

  Map yamlConfig;
  // If none set try flutter_launcher_icons.yaml first then pubspec.yaml
  // for compatibility
  if (configFile == defaultConfigFile || configFile == null) {
    try {
      yamlConfig = await loadConfigFile(defaultConfigFile);
    } catch (e) {
      if (configFile == null) {
        try {
          // Try pubspec.yaml for compatibility
          yamlConfig = await loadConfigFile("pubspec.yaml");
        } catch (_) {
          if (verbose) {
            stderr.writeln(e);
          }
        }
      } else {
        if (verbose) {
          stderr.writeln(e);
        }
      }
    }
  } else {
    try {
      yamlConfig = await loadConfigFile(configFile);
    } catch (e) {
      if (verbose) {
        stderr.writeln(e);
      }
    }
  }
  return yamlConfig;
}

Future<Map> loadConfigFile(String path) async {
  var config = await loadConfig(path);
  return config;
}

Map loadFlutterIconsConfig(Map config) {
  return config["flutter_icons"];
}

bool isImagePathInConfig(Map flutterIconsConfig) {
  return flutterIconsConfig.containsKey("image_path") ||
      (flutterIconsConfig.containsKey("image_path_android") &&
          flutterIconsConfig.containsKey("image_path_ios"));
}

bool hasAndroidOrIOSConfig(Map flutterIconsConfig) {
  return flutterIconsConfig.containsKey("android") ||
      flutterIconsConfig.containsKey("ios");
}

bool hasAndroidConfig(Map flutterIconsConfig) {
  return flutterIconsConfig.containsKey("android");
}

bool isNeedingNewAndroidIcon(Map flutterIconsConfig) {
  if (hasAndroidConfig(flutterIconsConfig)) {
    if (flutterIconsConfig['android'] != false) {
      return true;
    }
  }
  return false;
}

bool hasAndroidAdaptiveConfig(Map flutterIconsConfig) {
  return isNeedingNewAndroidIcon(flutterIconsConfig) &&
      flutterIconsConfig.containsKey("adaptive_icon_background") &&
      flutterIconsConfig.containsKey("adaptive_icon_foreground");
}

bool hasIOSConfig(Map flutterIconsConfig) {
  return flutterIconsConfig.containsKey("ios");
}

bool isNeedingNewIOSIcon(Map flutterIconsConfig) {
  if (hasIOSConfig(flutterIconsConfig)) {
    if (flutterIconsConfig["ios"] != false) {
      return true;
    }
  }
  return false;
}
