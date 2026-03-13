import 'package:place_see_app/core/model/photos/photo_full_info.dart';
import 'package:place_see_app/core/model/photos/photo_profile_info.dart';

extension PhotoProfileInfoMapper on PhotoProfileInfo {
  PhotoFullInfo toFullInfo() {
    return PhotoFullInfo(id, place.id, userName ?? 'Путешественник', imageUrl, createdAt, false, place.name);
  }
}