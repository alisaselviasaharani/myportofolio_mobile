import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    required this.position,
    required this.company,
    required this.description,
    required this.type,
    this.period = '',
    this.link = '',
    this.id,
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;

  @JsonKey(name: 'title', defaultValue: '')
  final String position;

  @JsonKey(name: 'institution', defaultValue: '')
  final String company;

  @JsonKey(defaultValue: '')
  final String description;

  @JsonKey(name: 'category', defaultValue: '')
  final String type;

  @JsonKey(defaultValue: '')
  final String period;

  @JsonKey(name: 'website', defaultValue: '')
  final String link;

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
