import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_full_info.g.dart';

@JsonSerializable()
class PhotoFullInfo {
  final int id;
  final int placeId;
  final String userName;
  final String imageUrl;
  final DateTime? createdAt;
  final bool isMain;
  final String? placeName;

  PhotoFullInfo(this.id, this.placeId, this.userName, this.imageUrl, this.createdAt, this.isMain, this.placeName);

  factory PhotoFullInfo.fromJson(Map<String, dynamic> rawPhoto) => _$PhotoFullInfoFromJson(rawPhoto);
}