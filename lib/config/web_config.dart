import 'package:json_annotation/json_annotation.dart';

part 'web_config.g.dart';

/// The flutter_launcher_icons configuration set for Web
@JsonSerializable(
  anyMap: true,
  checked: true,
)
class WebConfig {
  /// Specifies weather to generate icons for web
  final bool generate;

  /// Image path for web
  @JsonKey(name: 'image_path')
  final String? imagePath;

  /// manifest.json's background_color
  @JsonKey(name: 'background_color')
  final String? backgroundColor;

  /// manifest.json's theme_color
  @JsonKey(name: 'theme_color')
  final String? themeColor;

  /// Creates an instance of [WebConfig]
  const WebConfig({
    this.generate = false,
    this.imagePath,
    this.backgroundColor,
    this.themeColor,
  });

  /// Creates [WebConfig] from [json]
  factory WebConfig.fromJson(Map<dynamic, dynamic> json) =>
      _$WebConfigFromJson(json);

  /// Creates [Map] from [WebConfig]
  Map<String, dynamic> toJson() => _$WebConfigToJson(this);

  @override
  String toString() => 'WebConfig: ${toJson()}';
}
