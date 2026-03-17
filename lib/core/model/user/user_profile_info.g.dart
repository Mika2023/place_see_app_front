// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileInfo _$UserProfileInfoFromJson(Map<String, dynamic> json) =>
    UserProfileInfo(
      (json['id'] as num).toInt(),
      json['nickname'] as String,
      json['avatarImageUrl'] as String?,
      json['email'] as String?,
    );

Map<String, dynamic> _$UserProfileInfoToJson(UserProfileInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'avatarImageUrl': instance.avatarImageUrl,
      'email': instance.email,
    };
