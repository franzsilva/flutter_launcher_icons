const fliConfigTemplate = r'''
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/icon-128x128.png"
  image_path_android: "assets/images/icon-710x599-android.png"
  image_path_ios: "assets/images/icon-1024x1024.png"
  adaptive_icon_background: "assets/images/christmas-background.png"
  adaptive_icon_foreground: "assets/images/icon-foreground-432x432.png"
  adaptive_icon_monochrome: "assets/images/icon-monochrome-432x432.png"
  min_sdk_android: 21
  remove_alpha_ios: false
  web:
    generate: true
    image_path: "app_icon.png" # filepath
    background_color: "#0175C2" # hex_color
    theme_color: "#0175C2" # hex_color
    apple_mobile_web_app_title: "demo"
    apple_mobile_web_app_status_bar_style: "hex_color"
  windows:
    generate: true
    image_path: "app_icon.png"
    icon_size: 48
  macos:
    generate: true
    image_path: "app_icon.png"
''';

const flavorFLIConfigTemplate = fliConfigTemplate;

const fliWebConfig = r'''
flutter_launcher_icons:
  web:
    generate: true
    image_path: "app_icon.png" # filepath
    background_color: "#0175C2" # hex_color
    theme_color: "#0175C2" # hex_color
    apple_mobile_web_app_title: "demo"
    apple_mobile_web_app_status_bar_style: "hex_color"
''';

const fliWindowsConfig = r'''
flutter_launcher_icons:
  windows:
    generate: true
    image_path: "app_icon.png"
    icon_size: 48
''';

const invalidfliConfigTemplate = r'''
# flutter_launcher_icons
android: true
ios: true
image_path: "assets/images/icon-128x128.png"
 ad
image_path_android: "assets/images/icon-710x599-android.png"
image_path_ios: "assets/images/icon-1024x1024.png"
adaptive_icon_background: "assets/images/christmas-background.png"
adaptive_icon_foreground: "assets/images/icon-foreground-432x432.png"
adaptive_icon_monochrome: "assets/images/icon-monochrome-432x432.png"
web:
  generate: true
  image_path: "app_icon.png" # filepath
  background_color: "#0175C2" # hex_color
  theme_color: "#0175C2" # hex_color
  apple_mobile_web_app_title: "demo"
  apple_mobile_web_app_status_bar_style: "hex_color"
''';

const pubspecTemplate = r'''
name: demo
description: A new Flutter project.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=2.18.0-44.1.beta <3.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
  flutter_launcher_icons:
    path: C:/Users/asus/projects/flutter_launcher_icons

flutter:
  uses-material-design: true
  assets:
    - images/a_dot_burr.jpeg
    - images/a_dot_ham.jpeg
  fonts:
    - family: Schyler
      fonts:
        - asset: fonts/Schyler-Regular.ttf
        - asset: fonts/Schyler-Italic.ttf
          style: italic
    - family: Trajan Pro
      fonts:
        - asset: fonts/TrajanPro.ttf
        - asset: fonts/TrajanPro_Bold.ttf
          weight: 700

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/icon-128x128.png"
  image_path_android: "assets/images/icon-710x599-android.png"
  image_path_ios: "assets/images/icon-1024x1024.png"
  adaptive_icon_background: "assets/images/christmas-background.png"
  adaptive_icon_foreground: "assets/images/icon-foreground-432x432.png"
  adaptive_icon_monochrome: "assets/images/icon-monochrome-432x432.png"
  min_sdk_android: 21
  remove_alpha_ios: false
  web:
    generate: true
    image_path: "app_icon.png" # filepath
    image_path_favicon: "app_icon.png" # filepath
    background_color: "#0175C2" # hex_color
    theme_color: "#0175C2" # hex_color
    apple_mobile_web_app_title: "demo"
    apple_mobile_web_app_status_bar_style: "hex_color"
  windows:
    generate: true
    image_path: "app_icon.png"
    icon_size: 48
  macos:
    generate: true
    image_path: "app_icon.png"
''';

const invalidPubspecTemplate = r'''
name: demo
description: A new Flutter project.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=2.18.0-44.1.beta <3.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
  flutter_launcher_icons:
    path: C:/Users/asus/projects/flutter_launcher_icons

flutter:
  uses-material-design: true
  assets:
    - images/a_dot_burr.jpeg
    - images/a_dot_ham.jpeg
  fonts:
    - family: Schyler
      fonts:
        - asset: fonts/Schyler-Regular.ttf
        - asset: fonts/Schyler-Italic.ttf
          style: italic
    - family: Trajan Pro
      fonts:
        - asset: fonts/TrajanPro.ttf
        - asset: fonts/TrajanPro_Bold.ttf
          weight: 700

flutter_launcher_icons:
  android: true
 invalid_indented_key_key
  ios: true
  image_path: "assets/images/icon-128x128.png"
  image_path_android: "assets/images/icon-710x599-android.png"
  image_path_ios: "assets/images/icon-1024x1024.png"
  adaptive_icon_background: "assets/images/christmas-background.png"
  adaptive_icon_foreground: "assets/images/icon-foreground-432x432.png"
  adaptive_icon_monochrome: "assets/images/icon-monochrome-432x432.png"
  web:
    generate: true
    image_path: "app_icon.png" # filepath
    background_color: "#0175C2" # hex_color
    theme_color: "#0175C2" # hex_color
    apple_mobile_web_app_title: "demo"
    apple_mobile_web_app_status_bar_style: "hex_color"
  windows:
    generate: true
    image_path: "app_icon.png"
    icon_size: 48
''';

const webManifestTemplate = r'''
{
  "name": "demo",
  "short_name": "demo",
  "start_url": ".",
  "display": "standalone",
  "background_color": "#0175C2",
  "theme_color": "#0175C2",
  "description": "A new Flutter project.",
  "orientation": "portrait-primary",
  "prefer_related_applications": false,
  "icons": [
    {
      "src": "icons/Icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-maskable-192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "maskable"
    },
    {
      "src": "icons/Icon-maskable-512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "maskable"
    }
  ]
}
''';

const webIndexTemplate = r'''
<!DOCTYPE html>
<html>
<head>
  <!--
    If you are serving your web app in a path other than the root, change the
    href value below to reflect the base path you are serving from.

    The path provided below has to start and end with a slash "/" in order for
    it to work correctly.

    For more details:
    * https://developer.mozilla.org/en-US/docs/Web/HTML/Element/base

    This is a placeholder for base href that will be replaced by the value of
    the `--base-href` argument provided to `flutter build`.
  -->
  <base href="$FLUTTER_BASE_HREF">

  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="A new Flutter project.">

  <!-- iOS meta tags & icons -->
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="demo">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">

  <!-- Favicon -->
  <link rel="icon" type="image/png" href="favicon.png"/>

  <title>demo</title>
  <link rel="manifest" href="manifest.json">

  <script>
    // The value below is injected by flutter build, do not touch.
    var serviceWorkerVersion = null;
  </script>
  <!-- This script adds the flutter initialization JS code -->
  <script src="flutter.js" defer></script>
</head>
<body>
  <script>
    window.addEventListener('load', function(ev) {
      // Download main.dart.js
      _flutter.loader.loadEntrypoint({
        serviceWorker: {
          serviceWorkerVersion: serviceWorkerVersion,
        }
      }).then(function(engineInitializer) {
        return engineInitializer.initializeEngine();
      }).then(function(appRunner) {
        return appRunner.runApp();
      });
    });
  </script>
</body>
</html>

''';

// macos
const macOSContentsJsonFile = r'''
{
    "info": {
        "version": 1,
        "author": "xcode"
    },
    "images": [
        {
            "size": "16x16",
            "idiom": "mac",
            "filename": "app_icon_16.png",
            "scale": "1x"
        },
        {
            "size": "16x16",
            "idiom": "mac",
            "filename": "app_icon_32.png",
            "scale": "2x"
        },
        {
            "size": "32x32",
            "idiom": "mac",
            "filename": "app_icon_32.png",
            "scale": "1x"
        },
        {
            "size": "32x32",
            "idiom": "mac",
            "filename": "app_icon_64.png",
            "scale": "2x"
        },
        {
            "size": "128x128",
            "idiom": "mac",
            "filename": "app_icon_128.png",
            "scale": "1x"
        },
        {
            "size": "128x128",
            "idiom": "mac",
            "filename": "app_icon_256.png",
            "scale": "2x"
        },
        {
            "size": "256x256",
            "idiom": "mac",
            "filename": "app_icon_256.png",
            "scale": "1x"
        },
        {
            "size": "256x256",
            "idiom": "mac",
            "filename": "app_icon_512.png",
            "scale": "2x"
        },
        {
            "size": "512x512",
            "idiom": "mac",
            "filename": "app_icon_512.png",
            "scale": "1x"
        },
        {
            "size": "512x512",
            "idiom": "mac",
            "filename": "app_icon_1024.png",
            "scale": "2x"
        }
    ]
}''';
