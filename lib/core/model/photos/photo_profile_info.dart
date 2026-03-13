import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:place_see_app/core/model/place/place_short_for_search.dart';

part 'photo_profile_info.g.dart';
part 'photo_profile_info.freezed.dart';

@freezed
class PhotoProfileInfo with _$PhotoProfileInfo{
  const factory PhotoProfileInfo({
    required int id,
    String? userName,
    required String imageUrl,
    DateTime? createdAt,
    required PlaceShortForSearch place
  }) = _PhotoProfileInfo;

  factory PhotoProfileInfo.fromJson(Map<String, dynamic> rawPhoto) => _$PhotoProfileInfoFromJson(rawPhoto);
}