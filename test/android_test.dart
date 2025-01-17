import 'dart:io';

import 'package:flutter_launcher_icons/android.dart' as android;
import 'package:flutter_launcher_icons/config/config.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:test/test.dart';

// unit tests for android.dart
void main() {
  test('Adaptive icon mipmap path is correct', () {
    const String path1 = 'android/app/src/main/res/';
    const String path2 = 'mipmap-anydpi-v26/';
    expect(android.isCorrectMipmapDirectoryForAdaptiveIcon(path1), false);
    expect(android.isCorrectMipmapDirectoryForAdaptiveIcon(path2), false);
    expect(
      android.isCorrectMipmapDirectoryForAdaptiveIcon(
        androidAdaptiveXmlFolder(null),
      ),
      true,
    );
  });

  test('Adaptive icon color', () {
    //for file not in only png format
    expect(android.isAdaptiveIconConfigColor('assets/icons/adaptive_icon_background.jpg'), equals(false));
    //for color bg
    expect(android.isAdaptiveIconConfigColor('#FFFFFF'), equals(true));
  });

  test('Correct number of adaptive foreground icons', () {
    expect(android.adaptiveForegroundIcons.length, 5);
  });

  test('Correct number of android launcher icons', () {
    expect(android.androidIcons.length, 5);
  });

  test('Config contains string for generating new launcher icons', () {
    final Map<String, dynamic> flutterIconsConfig = <String, dynamic>{
      'image_path': 'assets/images/icon-710x599.png',
      'android': true,
      'ios': true,
    };
    expect(
      Config.fromJson(flutterIconsConfig).isCustomAndroidFile,
      isFalse,
    );

    final Map<String, dynamic> flutterIconsNewIconConfig = <String, dynamic>{
      'image_path': 'assets/images/icon-710x599.png',
      'android': 'New Icon',
      'ios': true,
    };
    expect(
      Config.fromJson(flutterIconsNewIconConfig).isCustomAndroidFile,
      isTrue,
    );
  });

  test('Prioritise image_path_android over image_path', () {
    final Map<String, dynamic> flutterIconsNewIconConfig = <String, dynamic>{
      'image_path': 'assets/images/icon-710x599.png',
      'image_path_android': 'assets/images/icon-android.png',
      'android': 'New Icon',
      'ios': true,
    };
    expect(
      Config.fromJson(flutterIconsNewIconConfig).getImagePathAndroid(),
      equals('assets/images/icon-android.png'),
    );
  });

  test('Transforming manifest without icon must add icon', () async {
    final String inputManifest =
        getAndroidManifestExample('android:icon="@mipmap/ic_launcher"');
    final String expectedManifest =
        getAndroidManifestExample('android:icon="@mipmap/ic_other_icon_name"');

    await withTempFile('AndroidManifest.xml', (File androidManifestFile) async {
      androidManifestFile.writeAsStringSync(inputManifest);
      await android.overwriteAndroidManifestWithNewLauncherIcon(
        'ic_other_icon_name',
        androidManifestFile,
      );
      expect(androidManifestFile.readAsStringSync(), equals(expectedManifest));
    });
  });

  test('Transforming manifest with icon already in place should leave it unchanged', () async {
    final String inputManifest = getAndroidManifestExample('android:icon="@mipmap/ic_launcher"');
    final String expectedManifest = getAndroidManifestExample('android:icon="@mipmap/ic_launcher"');

    await withTempFile('AndroidManifest.xml', (File androidManifestFile) async {
      androidManifestFile.writeAsStringSync(inputManifest);
      await android.overwriteAndroidManifestWithNewLauncherIcon(
        'ic_launcher',
        androidManifestFile,
      );
      expect(androidManifestFile.readAsStringSync(), equals(expectedManifest));
    });
  });

  test('Transforming manifest with trailing newline should keep newline untouched', () async {
    final String inputManifest = getAndroidManifestExample('android:icon="@mipmap/ic_launcher"') + '\n';
    final String expectedManifest = inputManifest;

    await withTempFile('AndroidManifest.xml', (File androidManifestFile) async {
      androidManifestFile.writeAsStringSync(inputManifest);
      await android.overwriteAndroidManifestWithNewLauncherIcon(
        'ic_launcher',
        androidManifestFile,
      );
      expect(androidManifestFile.readAsStringSync(), equals(expectedManifest));
    });
  });

  test('Transforming manifest with 3 trailing newlines should keep newlines untouched', () async {
    final String inputManifest = getAndroidManifestExample('android:icon="@mipmap/ic_launcher"') + '\n\n\n';
    final String expectedManifest = inputManifest;

    await withTempFile('AndroidManifest.xml', (File androidManifestFile) async {
      androidManifestFile.writeAsStringSync(inputManifest);
      await android.overwriteAndroidManifestWithNewLauncherIcon(
        'ic_launcher',
        androidManifestFile,
      );
      expect(androidManifestFile.readAsStringSync(), equals(expectedManifest));
    });
  });

  test('Transforming manifest with special newline characters should leave special newline characters untouched',
      () async {
    final String inputManifest =
        getAndroidManifestExample('android:icon="@mipmap/ic_launcher"').replaceAll('\n', '\r\n');
    final String expectedManifest = inputManifest;

    await withTempFile('AndroidManifest.xml', (File androidManifestFile) async {
      androidManifestFile.writeAsStringSync(inputManifest);
      await android.overwriteAndroidManifestWithNewLauncherIcon(
        'ic_launcher',
        androidManifestFile,
      );
      expect(androidManifestFile.readAsStringSync(), equals(expectedManifest));
    });
  });
}

Future<void> withTempFile(String fileName, Function block) async {
  final Directory tempDir = Directory.systemTemp.createTempSync();
  final File file = File('${tempDir.path}/$fileName')..createSync();
  if (!file.existsSync()) {
    fail('Could not create temp test file ${file.path}');
  }
  try {
    await block(file);
  } finally {
    file.deleteSync();
  }
}

String getAndroidManifestExample(String iconLine) {
  return '''
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.myapplication">

    <application
        android:allowBackup="true"
        $iconLine
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/AppTheme">
        <activity
            android:name=".MainActivity"
            android:label="@string/app_name"
            android:theme="@style/AppTheme.NoActionBar">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
  '''
      .trim();
}
