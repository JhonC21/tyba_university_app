import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'university.freezed.dart';
part 'university.g.dart';

@freezed
class University with _$University {
  @JsonSerializable(explicitToJson: true)
  const factory University({
    @JsonKey(name: 'alpha_two_code') required String alphaTwoCode,
    required String name,
    required String country,
    @JsonKey(name: 'state-province') String? stateProvince,
    required List<String> domains,
    @JsonKey(name: 'web_pages') required List<String> webPages,
    @JsonKey(includeFromJson: false, includeToJson: false) File? imageFile,
    int? studentCount,
  }) = _University;

  factory University.fromJson(Map<String, dynamic> json) =>
      _$UniversityFromJson(json);
}
