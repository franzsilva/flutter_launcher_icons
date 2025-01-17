// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebConfig _$WebConfigFromJson(Map json) => $checkedCreate(
      'WebConfig',
      json,
      ($checkedConvert) {
        final val = WebConfig(
          generate: $checkedConvert('generate', (v) => v as bool? ?? false),
          imagePath: $checkedConvert('image_path', (v) => v as String?),
          imagePathFavicon:
              $checkedConvert('image_path_favicon', (v) => v as String?),
          backgroundColor:
              $checkedConvert('background_color', (v) => v as String?),
          themeColor: $checkedConvert('theme_color', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'imagePath': 'image_path',
        'imagePathFavicon': 'image_path_favicon',
        'backgroundColor': 'background_color',
        'themeColor': 'theme_color'
      },
    );

Map<String, dynamic> _$WebConfigToJson(WebConfig instance) => <String, dynamic>{
      'generate': instance.generate,
      'image_path': instance.imagePath,
      'image_path_favicon': instance.imagePathFavicon,
      'background_color': instance.backgroundColor,
      'theme_color': instance.themeColor,
    };
