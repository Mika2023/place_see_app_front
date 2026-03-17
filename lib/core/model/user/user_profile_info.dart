import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_info.g.dart';

@JsonSerializable()
class UserProfileInfo {
  final int id;
  final String nickname;
  final String? avatarImageUrl;
  final String? email;

  UserProfileInfo(this.id, this.nickname, this.avatarImageUrl, this.email);

  factory UserProfileInfo.fromJson(Map<String, dynamic> rawUser) => _$UserProfileInfoFromJson(rawUser);
}