// ignore_for_file: public_member_api_docs

import 'dart:convert';
import 'dart:io';

import 'package:flutter_launcher_icons/config/config.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:image/image.dart';

/// File to handle the creation of icons for iOS platform
class IosIconTemplate {
  /// constructs an instance of [IosIconTemplate]
  IosIconTemplate({required this.size, required this.name});

  /// suffix of the icon name
  final String name;

  /// the size of the icon
  final int size;
}

/// details of the ios icons which need to be generated
List<IosIconTemplate> legacyIosIcons = <IosIconTemplate>[
  IosIconTemplate(name: '-20x20@1x', size: 20),
  IosIconTemplate(name: '-20x20@2x', size: 40),
  IosIconTemplate(name: '-20x20@3x', size: 60),
  IosIconTemplate(name: '-29x29@1x', size: 29),
  IosIconTemplate(name: '-29x29@2x', size: 58),
  IosIconTemplate(name: '-29x29@3x', size: 87),
  IosIconTemplate(name: '-40x40@1x', size: 40),
  IosIconTemplate(name: '-40x40@2x', size: 80),
  IosIconTemplate(name: '-40x40@3x', size: 120),
  IosIconTemplate(name: '-50x50@1x', size: 50),
  IosIconTemplate(name: '-50x50@2x', size: 100),
  IosIconTemplate(name: '-57x57@1x', size: 57),
  IosIconTemplate(name: '-57x57@2x', size: 114),
  IosIconTemplate(name: '-60x60@2x', size: 120),
  IosIconTemplate(name: '-60x60@3x', size: 180),
  IosIconTemplate(name: '-72x72@1x', size: 72),
  IosIconTemplate(name: '-72x72@2x', size: 144),
  IosIconTemplate(name: '-76x76@1x', size: 76),
  IosIconTemplate(name: '-76x76@2x', size: 152),
  IosIconTemplate(name: '-83.5x83.5@2x', size: 167),
  IosIconTemplate(name: '-1024x1024@1x', size: 1024),
];

List<IosIconTemplate> iosIcons = <IosIconTemplate>[
  IosIconTemplate(name: '-20x20@2x', size: 40),
  IosIconTemplate(name: '-20x20@3x', size: 60),
  IosIconTemplate(name: '-29x29@2x', size: 58),
  IosIconTemplate(name: '-29x29@3x', size: 87),
  IosIconTemplate(name: '-38x38@2x', size: 76),
  IosIconTemplate(name: '-38x38@3x', size: 114),
  IosIconTemplate(name: '-40x40@2x', size: 80),
  IosIconTemplate(name: '-40x40@3x', size: 120),
  IosIconTemplate(name: '-60x60@2x', size: 120),
  IosIconTemplate(name: '-60x60@3x', size: 180),
  IosIconTemplate(name: '-64x64@2x', size: 128),
  IosIconTemplate(name: '-64x64@3x', size: 192),
  IosIconTemplate(name: '-68x68@2x', size: 136),
  IosIconTemplate(name: '-76x76@2x', size: 152),
  IosIconTemplate(name: '-83.5x83.5@2x', size: 167),
  IosIconTemplate(name: '-1024x1024@1x', size: 1024),
];

/// create the ios icons
void createIcons(Config config, String? flavor) {
  // TODO(p-mazhnik): support prefixPath
  final String? filePath = config.getImagePathIOS();
  final String? darkFilePath = config.imagePathIOSDarkTransparent;
  final String? tintedFilePath = config.imagePathIOSTintedGrayscale;

  if (filePath == null) {
    throw const InvalidConfigException(errorMissingImagePath);
  }

  // decodeImageFile shows error message if null
  // so can return here if image is null
  Image? image = decodeImage(File(filePath).readAsBytesSync());
  if (image == null) {
    return;
  }

  // For dark and tinted images, return here if path was specified but image is null
  Image? darkImage;
  if (darkFilePath != null) {
    darkImage = decodeImage(File(darkFilePath).readAsBytesSync());
    if (darkImage == null) {
      return;
    }
  }

  Image? tintedImage;
  if (tintedFilePath != null) {
    tintedImage = decodeImage(File(tintedFilePath).readAsBytesSync());
    if (tintedImage == null) {
      return;
    }
    if (config.desaturateTintedToGrayscaleIOS) {
      printStatus('Desaturating iOS tinted image to grayscale');
      tintedImage = grayscale(tintedImage);
    } else {
      // Check if the image is already grayscale
      final pixel = tintedImage.getPixel(0, 0);
      do {
        if (pixel.r != pixel.g || pixel.g != pixel.b) {
          print(
            '\nWARNING: Tinted iOS image is not grayscale.\nSet "desaturate_tinted_to_grayscale_ios: true" to desaturate it.\n',
          );
          break;
        }
      } while (pixel.moveNext());
    }
  }

  if (config.removeAlphaIOS && image.hasAlpha) {
    final backgroundColor = _getBackgroundColor(config);
    final pixel = image.getPixel(0, 0);
    do {
      pixel.set(_alphaBlend(pixel, backgroundColor));
    } while (pixel.moveNext());

    image = image.convert(numChannels: 3);
  }
  if (image.hasAlpha) {
    print(
      '\nWARNING: Icons with alpha channel are not allowed in the Apple App Store.\nSet "remove_alpha_ios: true" to remove it.\n',
    );
  }
  String iconName;
  String? darkIconName;
  String? tintedIconName;
  final List<IosIconTemplate> generateIosIcons =
      (darkImage == null && tintedImage == null) ? legacyIosIcons : iosIcons;
  final dynamic iosConfig = config.ios;
  if (flavor != null) {
    final String catalogName = 'AppIcon-$flavor';

    printStatus('Building iOS launcher icon for $flavor');
    for (IosIconTemplate template in generateIosIcons) {
      saveNewIcons(
        template: template,
        image: image,
        catalogName: catalogName,
        // Since this is the base icon name we are using the same name for the icon as the catalog name
        iconName: catalogName,
      );
    }

    if (darkImage != null) {
      darkIconName = 'AppIcon-$flavor-Dark';
      printStatus('Building iOS dark launcher icon for $flavor');
      for (IosIconTemplate template in generateIosIcons) {
        saveNewIcons(
          template: template,
          image: darkImage,
          catalogName: catalogName,
          iconName: darkIconName,
        );
      }
    }
    if (tintedImage != null) {
      tintedIconName = 'AppIcon-$flavor-Tinted';
      printStatus('Building iOS tinted launcher icon for $flavor');
      for (IosIconTemplate template in generateIosIcons) {
        saveNewIcons(
          template: template,
          image: tintedImage,
          catalogName: catalogName,
          iconName: tintedIconName,
        );
      }
    }
    iconName = iosDefaultIconName;
    changeIosLauncherIcon(catalogName, flavor);
    modifyContentsFile(catalogName, darkIconName, tintedIconName);
  } else if (iosConfig is String) {
    // If the IOS configuration is a string then the user has specified a new icon to be created
    // and for the old icon file to be kept
    final String newIconName = iosConfig;
    printStatus('Adding new iOS launcher icon');
    for (IosIconTemplate template in generateIosIcons) {
      saveNewIcons(
        template: template,
        image: image,
        catalogName: 'AppIcon',
        iconName: newIconName,
      );
    }
    if (darkImage != null) {
      darkIconName = newIconName + '-Dark';
      printStatus('Adding new iOS dark launcher icon');
      for (IosIconTemplate template in generateIosIcons) {
        saveNewIcons(
          template: template,
          image: darkImage,
          catalogName: 'AppIcon',
          iconName: darkIconName,
        );
      }
    }
    if (tintedImage != null) {
      tintedIconName = newIconName + '-Tinted';
      printStatus('Adding new iOS tinted launcher icon');
      for (IosIconTemplate template in generateIosIcons) {
        saveNewIcons(
          template: template,
          image: tintedImage,
          catalogName: 'AppIcon',
          iconName: tintedIconName,
        );
      }
    }
    iconName = newIconName;
    changeIosLauncherIcon(iconName, flavor);
    modifyContentsFile(iconName, darkIconName, tintedIconName);
  }
  // Otherwise the user wants the new icon to use the default icons name and
  // update config file to use it
  else {
    printStatus('Overwriting default iOS launcher icon with new icon');
    for (IosIconTemplate template in generateIosIcons) {
      overwriteDefaultIcons(template, image);
    }
    if (darkImage != null) {
      printStatus('Overwriting default iOS dark launcher icon with new icon');
      for (IosIconTemplate template in generateIosIcons) {
        overwriteDefaultIcons(template, darkImage, '-Dark');
      }
      darkIconName = iosDefaultIconName + '-Dark';
    }
    if (tintedImage != null) {
      printStatus('Overwriting default iOS tinted launcher icon with new icon');
      for (IosIconTemplate template in generateIosIcons) {
        overwriteDefaultIcons(template, tintedImage, '-Tinted');
      }
      tintedIconName = iosDefaultIconName + '-Tinted';
    }
    iconName = iosDefaultIconName;
    changeIosLauncherIcon('AppIcon', flavor);
    // Still need to modify the Contents.json file
    // since the user could have added dark and tinted icons
    modifyDefaultContentsFile(iconName, darkIconName, tintedIconName);
  }
}

/// Note: Do not change interpolation unless you end up with better results (see issue for result when using cubic
/// interpolation)
/// https://github.com/fluttercommunity/flutter_launcher_icons/issues/101#issuecomment-495528733
void overwriteDefaultIcons(
  IosIconTemplate template,
  Image image, [
  String iconNameSuffix = '',
]) {
  final Image newFile = createResizedImage(template, image);
  File(
    iosDefaultIconFolder +
        iosDefaultIconName +
        iconNameSuffix +
        template.name +
        '.png',
  )..writeAsBytesSync(encodePng(newFile));
}

/// Note: Do not change interpolation unless you end up with better results (see issue for result when using cubic
/// interpolation)
/// https://github.com/fluttercommunity/flutter_launcher_icons/issues/101#issuecomment-495528733
void saveNewIcons({
  required IosIconTemplate template,
  required Image image,
  required String catalogName,
  required String iconName,
}) {
  final String newIconFolder = iosAssetFolder + catalogName + '.appiconset/';
  final Image newFile = createResizedImage(template, image);
  File(newIconFolder + iconName + template.name + '.png')
      .create(recursive: true)
      .then((File file) {
    file.writeAsBytesSync(encodePng(newFile));
  });
}

/// create resized icon image
Image createResizedImage(IosIconTemplate template, Image image) {
  if (image.width >= template.size) {
    return copyResize(
      image,
      width: template.size,
      height: template.size,
      interpolation: Interpolation.average,
    );
  } else {
    return copyResize(
      image,
      width: template.size,
      height: template.size,
      interpolation: Interpolation.linear,
    );
  }
}

/// Change the iOS launcher icon
Future<void> changeIosLauncherIcon(String iconName, String? flavor) async {
  final File iOSConfigFile = File(iosConfigFile);
  final List<String> lines = await iOSConfigFile.readAsLines();

  bool onConfigurationSection = false;
  String? currentConfig;

  for (int x = 0; x < lines.length; x++) {
    final String line = lines[x];
    if (line.contains('/* Begin XCBuildConfiguration section */')) {
      onConfigurationSection = true;
    }
    if (line.contains('/* End XCBuildConfiguration section */')) {
      onConfigurationSection = false;
    }
    if (onConfigurationSection) {
      final match = RegExp('.*/\\* (.*)\.xcconfig \\*/;').firstMatch(line);
      if (match != null) {
        currentConfig = match.group(1);
      }

      if (currentConfig != null &&
          (flavor == null || currentConfig.contains('-$flavor')) &&
          line.contains('ASSETCATALOG') &&  line.contains('APPICON_NAME')) {
        lines[x] = line.replaceAll(RegExp('\=(.*);'), '= $iconName;');
      }
    }
  }

  final String entireFile = '${lines.join('\n')}\n';
  await iOSConfigFile.writeAsString(entireFile);
}

/// Create the Contents.json file
void modifyContentsFile(
  String newIconName,
  String? darkIconName,
  String? tintedIconName,
) {
  final String newIconFolder =
      iosAssetFolder + newIconName + '.appiconset/Contents.json';
  File(newIconFolder).create(recursive: true).then((File contentsJsonFile) {
    final String contentsFileContent =
        generateContentsFileAsString(newIconName, darkIconName, tintedIconName);
    contentsJsonFile.writeAsString(contentsFileContent);
  });
}

/// Modify default Contents.json file
void modifyDefaultContentsFile(
  String newIconName,
  String? darkIconName,
  String? tintedIconName,
) {
  const String newIconFolder =
      iosAssetFolder + 'AppIcon.appiconset/Contents.json';
  File(newIconFolder).create(recursive: true).then((File contentsJsonFile) {
    final String contentsFileContent =
        generateContentsFileAsString(newIconName, darkIconName, tintedIconName);
    contentsJsonFile.writeAsString(contentsFileContent);
  });
}

String generateContentsFileAsString(
  String newIconName,
  String? darkIconName,
  String? tintedIconName,
) {
  final List<Map<String, dynamic>> imageList;
  if (darkIconName == null && tintedIconName == null) {
    imageList = createLegacyImageList(newIconName);
  } else {
    imageList = createImageList(newIconName, darkIconName, tintedIconName);
  }
  final Map<String, dynamic> contentJson = <String, dynamic>{
    'images': imageList,
    'info': ContentsInfoObject(version: 1, author: 'xcode').toJson(),
  };
  return json.encode(contentJson);
}

class ContentsImageAppearanceObject {
  ContentsImageAppearanceObject({
    required this.appearance,
    required this.value,
  });

  final String appearance;
  final String value;

  Map<String, String> toJson() {
    return <String, String>{
      'appearance': appearance,
      'value': value,
    };
  }
}

class ContentsImageObject {
  ContentsImageObject({
    required this.size,
    required this.idiom,
    required this.filename,
    required this.scale,
    this.platform,
    this.appearances,
  });

  final String size;
  final String idiom;
  final String filename;
  final String scale;
  final String? platform;
  final List<ContentsImageAppearanceObject>? appearances;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'size': size,
      'idiom': idiom,
      'filename': filename,
      'scale': scale,
      if (platform != null) 'platform': platform,
      if (appearances != null)
        'appearances': appearances!.map((e) => e.toJson()).toList(),
    };
  }
}

class ContentsInfoObject {
  ContentsInfoObject({required this.version, required this.author});

  final int version;
  final String author;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'version': version,
      'author': author,
    };
  }
}

/// Create the image list for the Contents.json file for Xcode versions below Xcode 14
List<Map<String, dynamic>> createLegacyImageList(String fileNamePrefix) {
  const List<Map<String, dynamic>> imageConfigurations = [
    {
      'size': '20x20',
      'idiom': 'iphone',
      'scales': ['2x', '3x'],
    },
    {
      'size': '29x29',
      'idiom': 'iphone',
      'scales': ['1x', '2x', '3x'],
    },
    {
      'size': '40x40',
      'idiom': 'iphone',
      'scales': ['2x', '3x'],
    },
    {
      'size': '57x57',
      'idiom': 'iphone',
      'scales': ['1x', '2x'],
    },
    {
      'size': '60x60',
      'idiom': 'iphone',
      'scales': ['2x', '3x'],
    },
    {
      'size': '20x20',
      'idiom': 'ipad',
      'scales': ['1x', '2x'],
    },
    {
      'size': '29x29',
      'idiom': 'ipad',
      'scales': ['1x', '2x'],
    },
    {
      'size': '40x40',
      'idiom': 'ipad',
      'scales': ['1x', '2x'],
    },
    {
      'size': '50x50',
      'idiom': 'ipad',
      'scales': ['1x', '2x'],
    },
    {
      'size': '72x72',
      'idiom': 'ipad',
      'scales': ['1x', '2x'],
    },
    {
      'size': '76x76',
      'idiom': 'ipad',
      'scales': ['1x', '2x'],
    },
    {
      'size': '83.5x83.5',
      'idiom': 'ipad',
      'scales': ['2x'],
    },
    {
      'size': '1024x1024',
      'idiom': 'ios-marketing',
      'scales': ['1x'],
    },
  ];

  final List<Map<String, dynamic>> imageList = <Map<String, dynamic>>[];

  for (final config in imageConfigurations) {
    final size = config['size']!;
    final idiom = config['idiom']!;
    final List<String> scales = config['scales'];

    for (final scale in scales) {
      final filename = '$fileNamePrefix-$size@$scale.png';
      imageList.add(
        ContentsImageObject(
          size: size,
          idiom: idiom,
          filename: filename,
          scale: scale,
        ).toJson(),
      );
    }
  }

  return imageList;
}

/// Create the image list for the Contents.json file for Xcode versions Xcode 14 and above
List<Map<String, dynamic>> createImageList(
  String fileNamePrefix,
  String? darkFileNamePrefix,
  String? tintedFileNamePrefix,
) {
  const List<Map<String, dynamic>> imageConfigurations = [
    {
      'size': '20x20',
      'idiom': 'universal',
      'platform': 'ios',
      'scales': ['2x', '3x'],
    },
    {
      'size': '29x29',
      'idiom': 'universal',
      'platform': 'ios',
      'scales': ['2x', '3x'],
    },
    {
      'size': '38x38',
      'idiom': 'universal',
      'platform': 'ios',
      'scales': ['2x', '3x'],
    },
    {
      'size': '40x40',
      'idiom': 'universal',
      'platform': 'ios',
      'scales': ['2x', '3x'],
    },
    {
      'size': '60x60',
      'idiom': 'universal',
      'platform': 'ios',
      'scales': ['2x', '3x'],
    },
    {
      'size': '64x64',
      'idiom': 'universal',
      'platform': 'ios',
      'scales': ['2x', '3x'],
    },
    {
      'size': '68x68',
      'idiom': 'universal',
      'platform': 'ios',
      'scales': ['2x'],
    },
    {
      'size': '76x76',
      'idiom': 'universal',
      'platform': 'ios',
      'scales': ['2x'],
    },
    {
      'size': '83.5x83.5',
      'idiom': 'universal',
      'platform': 'ios',
      'scales': ['2x'],
    },
    {
      'size': '1024x1024',
      'idiom': 'universal',
      'platform': 'ios',
      'scales': ['1x'],
    },
    {
      'size': '1024x1024',
      'idiom': 'ios-marketing',
      'scales': ['1x'],
    },
  ];

  final List<Map<String, dynamic>> imageList = <Map<String, dynamic>>[];

  for (final config in imageConfigurations) {
    final size = config['size']!;
    final idiom = config['idiom']!;
    final platform = config['platform'];
    final List<String> scales = config['scales'];

    for (final scale in scales) {
      final filename = '$fileNamePrefix-$size@$scale.png';
      imageList.add(
        ContentsImageObject(
          size: size,
          idiom: idiom,
          filename: filename,
          platform: platform,
          scale: scale,
        ).toJson(),
      );
    }
  }

  // Prevent ios-marketing icon from being tinted or dark

  if (darkFileNamePrefix != null) {
    for (final config
        in imageConfigurations.where((e) => e['idiom'] == 'universal')) {
      final size = config['size']!;
      final idiom = config['idiom']!;
      final platform = config['platform'];
      final List<String> scales = config['scales'];

      for (final scale in scales) {
        final filename = '$darkFileNamePrefix-$size@$scale.png';
        imageList.add(
          ContentsImageObject(
            size: size,
            idiom: idiom,
            filename: filename,
            platform: platform,
            scale: scale,
            appearances: <ContentsImageAppearanceObject>[
              ContentsImageAppearanceObject(
                appearance: 'luminosity',
                value: 'dark',
              ),
            ],
          ).toJson(),
        );
      }
    }
  }

  if (tintedFileNamePrefix != null) {
    for (final config
        in imageConfigurations.where((e) => e['idiom'] == 'universal')) {
      final size = config['size']!;
      final idiom = config['idiom']!;
      final platform = config['platform'];
      final List<String> scales = config['scales'];

      for (final scale in scales) {
        final filename = '$tintedFileNamePrefix-$size@$scale.png';
        imageList.add(
          ContentsImageObject(
            size: size,
            idiom: idiom,
            filename: filename,
            platform: platform,
            scale: scale,
            appearances: <ContentsImageAppearanceObject>[
              ContentsImageAppearanceObject(
                appearance: 'luminosity',
                value: 'tinted',
              ),
            ],
          ).toJson(),
        );
      }
    }
  }

  return imageList;
}

ColorUint8 _getBackgroundColor(Config config) {
  final backgroundColorHex = config.backgroundColorIOS.startsWith('#')
      ? config.backgroundColorIOS.substring(1)
      : config.backgroundColorIOS;
  if (backgroundColorHex.length != 6) {
    throw Exception('background_color_ios hex should be 6 characters long');
  }

  final backgroundByte = int.parse(backgroundColorHex, radix: 16);
  return ColorUint8.rgba(
    (backgroundByte >> 16) & 0xff,
    (backgroundByte >> 8) & 0xff,
    (backgroundByte >> 0) & 0xff,
    0xff,
  );
}

Color _alphaBlend(Color fg, ColorUint8 bg) {
  if (fg.format != Format.uint8) {
    fg = fg.convert(format: Format.uint8);
  }
  if (fg.a == 0) {
    return bg;
  } else {
    final invAlpha = 0xff - fg.a;
    return ColorUint8.rgba(
      (fg.a * fg.r + invAlpha * bg.g) ~/ 0xff,
      (fg.a * fg.g + invAlpha * bg.a) ~/ 0xff,
      (fg.a * fg.b + invAlpha * bg.b) ~/ 0xff,
      0xff,
    );
  }
}
