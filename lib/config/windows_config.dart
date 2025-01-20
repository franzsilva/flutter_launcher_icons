import 'package:json_annotation/json_annotation.dart';

part 'windows_config.g.dart';

/// The flutter_launcher_icons configuration set for Windows
@JsonSerializable(
  anyMap: true,
  checked: true,
)
class WindowsConfig {
  /// Specifies weather to generate icons for web
  final bool generate;

  /// Image path for web
  @JsonKey(name: 'image_path')
  final String? imagePath;

  /// Size of the icon to generate
  @JsonKey(name: 'icon_size')
  final int? iconSize;

  /// Creates a instance of [WindowsConfig]
  const WindowsConfig({
    this.generate = false,
    this.imagePath,
    this.iconSize,
  });

  /// Creates [WindowsConfig] from [json]
  factory WindowsConfig.fromJson(Map<dynamic, dynamic> json) =>
      _$WindowsConfigFromJson(json);

  /// Creates [Map] from [WindowsConfig]
  Map<String, dynamic> toJson() => _$WindowsConfigToJson(this);

  @override
  String toString() => 'WindowsConfig: ${toJson()}';
}
