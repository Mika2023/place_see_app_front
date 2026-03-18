import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_info.g.dart';
part 'user_profile_info.freezed.dart';

@freezed
class UserProfileInfo with _$UserProfileInfo {
  const factory UserProfileInfo({
    required int id,
    required String nickname,
    String? avatarImageUrl,
    String? email
  }) = _UserProfileInfo;

  factory UserProfileInfo.fromJson(Map<String, dynamic> rawUser) =>
      _$UserProfileInfoFromJson(rawUser);
}