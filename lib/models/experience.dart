import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

/// Experience portofolio yang disinkronkan dengan API Django REST Framework.
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

  /// UUID yang dihasilkan server; tidak ikut dikirim pada body POST.
  @JsonKey(includeToJson: false)
  final String? id;

  final String position;

  final String company;

  final String description;

  /// Tipe experience, mis. `Full-time`, `Internship`.
  @JsonKey(defaultValue: '')
  final String type;

  /// Periode dalam bentuk teks (opsional).
  @JsonKey(defaultValue: '')
  final String period;

  /// Tautan experience (opsional).
  @JsonKey(defaultValue: '')
  final String link;

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
