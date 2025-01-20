import 'package:json_annotation/json_annotation.dart';

part 'macos_config.g.dart';

/// The flutter_launcher_icons configuration set for MacOS
@JsonSerializable(
  anyMap: true,
  checked: true,
)
class MacOSConfig {
  /// Specifies weather to generate icons for macos
  @JsonKey()
  final bool generate;

  /// Image path for macos
  @JsonKey(name: 'image_path')
  final String? imagePath;

  /// Creates a instance of [MacOSConfig]
  const MacOSConfig({
    this.generate = false,
    this.imagePath,
  });

  /// Creates [WebConfig] from [json]
  factory MacOSConfig.fromJson(Map<dynamic, dynamic> json) =>
      _$MacOSConfigFromJson(json);

  /// Creates [Map] from [WebConfig]
  Map<String, dynamic> toJson() => _$MacOSConfigToJson(this);

  @override
  String toString() => '$runtimeType: ${toJson()}';
}
