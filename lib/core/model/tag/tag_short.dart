import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag_short.g.dart';

@JsonSerializable()
class TagShort {
  final String name;

  TagShort(this.name);

  factory TagShort.fromJson(Map<String, dynamic> rawTag) => _$TagShortFromJson(rawTag);
}